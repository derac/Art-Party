extends Control

# history format will be an array of arrays, sub arrays are segments from pen
# down to pen up, so undo will just be a pop and so on
var history := [[]]
var _pen = null
var mouse_history = PoolVector2Array()
var undo := false
var speed := 0

func _ready():
	var viewport = Viewport.new()
	var rect = get_rect()
	viewport.size = rect.size
	viewport.usage = Viewport.USAGE_2D
	
	viewport.render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
	viewport.render_target_v_flip = true
	
	_pen = Node2D.new()
	viewport.add_child(_pen)
	_pen.connect("draw", self, "_on_draw")
	add_child(viewport)
	
	var rt = viewport.get_texture()
	var board = TextureRect.new()
	board.set_texture(rt)
	add_child(board)
	
	mouse_history.append(get_viewport().get_mouse_position())

func _process(_delta):
	mouse_history.append(get_viewport().get_mouse_position())
	if mouse_history.size() > 15:
		mouse_history.remove(0)
	speed = average(mouse_history)

func average(positions : PoolVector2Array) -> int:
	var acc = 0
	for index in (positions.size() - 1):
		acc += (positions[index] - positions[index + 1]).length()
	acc /= (positions.size() - 1)
	return acc
	
# Input section
func _gui_input(event):
	if (event is InputEventMouseButton \
				and event.button_index == BUTTON_LEFT) \
				or event is InputEventScreenTouch:
		if event.pressed:
			history[-1].append({"position": get_viewport().get_mouse_position(),
								"speed": speed,
								"color": Global.color})
		elif history[-1].size() > 0:
			history.append([])
			history[-2] = brush_douglas_peucker(history[-2], 5)

	elif event is InputEventMouseMotion and \
				history[-1].size() > 0:
		history[-1].append({"position": mouse_history[-1],
							"speed": speed,
							"color": Global.color})
		_pen.update()
		
func _on_Undo_Button_button_down():
	if history.size() > 1:
		history.remove(history.size()-2)
		undo = true
		_pen.update()

# Drawing section
func _on_draw():
	if undo:
		_pen.draw_rect(get_rect(), Color("#f5f1ed"))
		for stroke in history:
			for index in range(stroke.size()):
#				draw_pen(stroke, index)
				draw_brush(stroke, index)

		undo = false
	if history[-1].size() > 0:
#		draw_pen(history[-1], history[-1].size() - 1)
		draw_brush(history[-1], history[-1].size() - 1)
	elif history.size() > 1:
#		draw_pen(history[-2], history[-2].size() - 1)
		draw_brush(history[-2], history[-2].size() - 1)

func draw_pen(stroke : Array, index : int) -> void:
	var radius = 10
	if index >= 1 and index < stroke.size():
		_pen.draw_circle(stroke[index]["position"],
						 radius,
						 stroke[index]["color"])
		_pen.draw_line(stroke[index - 1]["position"],
					   stroke[index]["position"],
					   stroke[index - 1]["color"],
					   radius * 2)

func draw_brush(stroke : Array, index : int) -> void:
	if index >= 1 and index < stroke.size():
		var tangent = (stroke[index - 1]["position"] - \
					   stroke[index]["position"]).tangent()
		if tangent == Vector2(0,0):
			tangent = Vector2(1,1)
		var factor = 3.5
		var base_width = 5
		var minus_width = 20
		var width = []
		for i in range(2):
			width.append(stroke[index - i]["speed"])
			if width[i] > minus_width * factor:
				width[i] = minus_width * factor
			width[i] = tangent.normalized() * \
					   (base_width + width[i] / factor)
		_pen.draw_circle(stroke[index]["position"],
						 width[0].length(),
						 stroke[index]["color"])
		if index == 1:
			_pen.draw_circle(stroke[0]["position"],
						 width[1].length(),
						 stroke[0]["color"])
		var points = PoolVector2Array()
		points.append(stroke[index]["position"] - width[0])
		points.append(stroke[index]["position"] + width[0])
		points.append(stroke[index - 1]["position"] + width[1])
		points.append(stroke[index - 1]["position"] - width[1])
		_pen.draw_polygon(points,PoolColorArray([stroke[index]["color"]]))

func brush_douglas_peucker(point_list : Array, epsilon : float) -> Array:
	var array_hist := []
	for pos in history[-2]:
		array_hist.append(pos["position"])
	array_hist = douglas_peucker(array_hist, .3)
	var new_stroke = []
	for pos in history[-2]:
		if array_hist.has(pos["position"]):
			new_stroke.append(pos)
	history[-2] = new_stroke
	return new_stroke
	
func douglas_peucker(point_list : Array, epsilon : float) -> Array:
	# Find the point with the maximum distance
	var dmax := 0
	var index := 0
	var end := point_list.size()
	for i in range(1, end):
		var d = perpendicular_distance(point_list[i],
									   point_list[0],
									   point_list[end - 1])
		if (d > dmax):
			index = i
			dmax = d
	
	# If max distance is greater than epsilon, recursively simplify
	if dmax > epsilon:
		return (douglas_peucker(point_list.slice(0, index), epsilon) +
				douglas_peucker(point_list.slice(index, end), epsilon))
	else:
		return [point_list[0], point_list[end - 1]]

func perpendicular_distance(p_test : Vector2, p1 : Vector2, p2 : Vector2) -> float:
	var two_times_area := abs((p2.y - p1.y) * p_test.x - (p2.x - p1.x) * 
						  p_test.y + p2.x * p1.y - p2.y * p1.x)
	var base_length := p1.distance_to(p2)
	if base_length > 0:
		return two_times_area / base_length
	else:
		return 0.0
