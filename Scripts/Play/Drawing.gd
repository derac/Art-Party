extends Control

# history format will be an array of arrays, sub arrays are segments from pen
# down to pen up, so undo will just be a pop and so on
var history := [[]]
var _pen = null
var redraw := false
var min_draw_dist := 1.0
var stroke_tools := load("res://Scripts/Utility/douglas-peucker.gd")

# Setting up drawing surface
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
	
# Input section
func _gui_input(event):
	if (event is InputEventMouseButton \
				and event.button_index == BUTTON_LEFT) \
				or event is InputEventScreenTouch:
		if event.pressed:
			history[-1].append({"position": get_viewport().get_mouse_position(),
								"speed": 0,
								"color": Global.color})
			_pen.update()
		elif history[-1].size() > 0:
			history.append([])
			history[-2] = stroke_tools.simplify_stroke(history[-2], 1.0 / 3)

	elif event is InputEventMouseMotion and \
				history[-1].size() > 0:
		if history[-1][-1]["position"].distance_to(get_viewport().get_mouse_position()) > min_draw_dist:
			history[-1].append({"position": get_viewport().get_mouse_position(),
								"speed": history[-1][-1]["position"].distance_to(get_viewport().get_mouse_position()),
								"color": Global.color})
			_pen.update()
		
func _on_Undo_Button_button_down():
	if history.size() > 1:
		history.remove(history.size()-2)
		redraw()

func redraw():
	redraw = true
	_pen.update()

# Drawing section
func _on_draw():
	if redraw:
		_pen.draw_rect(get_rect(), Color("#f5f1ed"))
		for stroke in history:
			for index in range(stroke.size()):
				draw_brush(stroke, index)
		redraw = false
	if history[-1].size() > 0:
		draw_brush(history[-1], history[-1].size() - 1)
	elif history.size() > 1 and history[-2].size() > 0:
		draw_brush(history[-2], history[-2].size() - 1)

func draw_brush(stroke : Array, index : int) -> void:
	var speed_factor = 2
	var base_width = 5
	var plus_width = 20
	if index >= 1 and index < stroke.size():
		var tangent = (stroke[index - 1]["position"] - \
					   stroke[index]["position"]).tangent()
		if tangent == Vector2(0,0):
			tangent = Vector2(1,1)
		var width = []
		for i in range(2):
			width.append(stroke[index - i]["speed"])
			if width[i] > plus_width * speed_factor:
				width[i] = plus_width * speed_factor
			width[i] = tangent.normalized() * \
					   (base_width + width[i] / speed_factor)
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
	elif index == 0:
		_pen.draw_circle(stroke[0]["position"],
					 base_width,
					 stroke[0]["color"])

