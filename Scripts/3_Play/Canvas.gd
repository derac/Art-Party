extends Control

# Array containing arrays which represent strokes
var history := [[]]
var viewport := Viewport.new()
var _pen := Node2D.new()
var viewport2 := Viewport.new()
var _pen2 := Node2D.new()
var redraw_next_frame := false
var min_draw_dist := 1.0
var stroke_tools := load("res://Scripts/Utility/douglas-peucker.gd")
var last_index := 0
onready var Color_Picker = get_node("/root/Play/Controls/Color_Picker")

func _ready() -> void:
	var render_target := viewport.get_texture()
	var board := TextureRect.new()
	viewport.size = get_rect().size
	viewport.usage = Viewport.USAGE_2D
	viewport.render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
	viewport.render_target_v_flip = true
	viewport.transparent_bg = true
	viewport.add_child(_pen)
	_pen.connect("draw", self, "_on_draw")
	add_child(viewport)
	board.set_texture(render_target)
	add_child(board)
	
	var render_target2 := viewport2.get_texture()
	var board2 := TextureRect.new()
	viewport2.size = get_rect().size
	viewport2.usage = Viewport.USAGE_2D
	viewport2.render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
	viewport2.render_target_v_flip = true
	viewport2.transparent_bg = true
	viewport2.add_child(_pen2)
	_pen2.connect("draw", self, "_on_draw2")
	add_child(viewport2)
	board2.set_texture(render_target2)
	add_child(board2)
	
func _gui_input(event) -> void:
	if (event is InputEventMouseButton \
				and event.button_index == BUTTON_LEFT) \
				or event is InputEventScreenTouch:
		last_index = 0
		if event.pressed:
			history[-1].append({"position": get_viewport().get_mouse_position(),
								"speed": 0,
								"color": Color_Picker.color})
			_pen2.update()
		elif history[-1].size() > 0:
			history.append([])
			history[-2] = stroke_tools.simplify_stroke(history[-2], 1.0 / 3)
			_pen.update()
	elif event is InputEventMouseMotion and history[-1].size():
		if history[-1][-1]["position"].distance_to(get_viewport().get_mouse_position()) > min_draw_dist:
			history[-1].append({"position": get_viewport().get_mouse_position(),
								"speed": history[-1][-1]["position"].distance_to(get_viewport().get_mouse_position()),
								"color": Color_Picker.color})
			_pen2.update()

func _on_draw() -> void:
	if history.size() > 1:
		viewport2.render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
		_pen2.update()
		for index in range(history[-2].size()):
			draw_brush(history[-2], index, _pen)
	if redraw_next_frame:
		viewport.render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
		for stroke in history:
			for index in range(stroke.size()):
				draw_brush(stroke, index, _pen)
		redraw_next_frame = false

func _on_draw2() -> void:
	if history[-1].size() > 1:
		for offset in range(0, history[-1].size() - last_index):
			draw_brush(history[-1], last_index + offset, _pen2)
		last_index = history[-1].size() - 1
	else:
		_pen2.draw_rect(get_rect(),Color(0,0,0,0))

func undo() -> void:
	if history.size() > 1:
		history.remove(history.size()-2)
		redraw()

func redraw() -> void:
	redraw_next_frame = true
	_pen.update()

func draw_brush(stroke : Array, index : int, pen : Node2D) -> void:
	var speed_factor := 3
	var base_width := 5
	var plus_width := 20
	if index >= 1 and index < stroke.size():
		var tangent : Vector2 = (stroke[index - 1]["position"] - \
								 stroke[index]["position"]).tangent()
		if tangent == Vector2(0,0):
			tangent = Vector2(1,1)
		var width := []
		for i in range(2):
			width.append(stroke[index - i]["speed"])
			if width[i] > plus_width * speed_factor:
				width[i] = plus_width * speed_factor
			width[i] = tangent.normalized() * \
					   (base_width + width[i] / speed_factor)
		pen.draw_circle(stroke[index]["position"],
						 width[0].length(),
						 stroke[index]["color"])
		if index == 1:
			pen.draw_circle(stroke[0]["position"],
							 width[1].length(),
							 stroke[0]["color"])
		var points = PoolVector2Array()
		points.append(stroke[index]["position"] - width[0])
		points.append(stroke[index]["position"] + width[0])
		points.append(stroke[index - 1]["position"] + width[1])
		points.append(stroke[index - 1]["position"] - width[1])
		pen.draw_polygon(points,PoolColorArray([stroke[index]["color"]]))
	elif index == 0:
		pen.draw_circle(stroke[0]["position"],
						 base_width,
						 stroke[0]["color"])

