extends Area2D

export var regen_time = 2
var initial_wood = 3
var wood = 0

func _ready():
	wood = initial_wood
	get_node("Label").set_text(str(wood))
	pass

func _on_Forest_input_event( viewport, event, shape_idx ):
	if (wood > 0):
		if (event.type==InputEvent.MOUSE_BUTTON and event.pressed):
			get_parent().add_wood()
			wood -= 1
			get_node("Label").set_text(str(wood))
