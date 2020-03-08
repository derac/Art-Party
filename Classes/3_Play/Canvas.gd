extends Control

# Array containing arrays which represent strokes
var history := [[]]
var viewports := [Viewport.new(), Viewport.new()]
var pens := [Node2D.new(), Node2D.new()]
var redraw_next_frame := false
var min_draw_dist := 1.0
var last_index := 0

const simplify_stroke = preload("res://Classes/Utility/simplify_stoke.gd")

func _ready() -> void:
	var callback_names = ["_draw_picture", "_draw_current_stroke"]
	for i in range(2):
		viewports[i].size = get_rect().size
		viewports[i].usage = Viewport.USAGE_2D
		viewports[i].render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
		viewports[i].render_target_v_flip = true
		viewports[i].transparent_bg = true
		viewports[i].add_child(pens[i])
		var board := TextureRect.new()
		board.set_texture(viewports[i].get_texture())
		add_child(viewports[i])
		add_child(board)
		pens[i].connect("draw", self, callback_names[i])
	
func _gui_input(event) -> void:
	var Color_Picker = get_node("/root/Play/Controls/Color_Picker")
	if (event is InputEventMouseButton \
			and event.button_index == BUTTON_LEFT) \
			or event is InputEventScreenTouch:
		last_index = 0
		if event.pressed:
			history[-1].append({"position": get_viewport().get_mouse_position(),
								"speed": 0,
								"color": Color_Picker.color})
			pens[1].update()
		elif history[-1].size() > 0:
			history.append([])
			history[-2] = simplify_stroke.simplify(history[-2], 1.0 / 3)
			viewports[1].render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
			pens[1].update()
			pens[0].update()
	elif event is InputEventMouseMotion and history[-1].size():
		if history[-1][-1]["position"].distance_to(get_viewport().get_mouse_position()) > min_draw_dist:
			history[-1].append({"position": get_viewport().get_mouse_position(),
								"speed": history[-1][-1]["position"].distance_to(get_viewport().get_mouse_position()),
								"color": Color_Picker.color})
			pens[1].update()

func _draw_picture() -> void:
	if redraw_next_frame:
		viewports[0].render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
		for stroke in history:
			for index in range(stroke.size()):
				draw_brush(stroke, index, pens[0])
		redraw_next_frame = false
	elif history.size() > 1:
		for index in range(history[-2].size()):
			draw_brush(history[-2], index, pens[0])

func _draw_current_stroke() -> void:
	if history[-1].size() > 1:
		for offset in range(0, history[-1].size() - last_index):
			draw_brush(history[-1], last_index + offset, pens[1])
		last_index = history[-1].size() - 1

func undo() -> void:
	if history.size() > 1:
		history.remove(history.size()-2)
		redraw()

func redraw() -> void:
	redraw_next_frame = true
	pens[0].update()

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

