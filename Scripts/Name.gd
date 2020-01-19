extends LineEdit

func _ready():
	text = Global.my_name

func _gui_input(event):
	Global.my_name = text
