extends Area2D

export var regen_time = 2
var initial_food = 3
var food = 0

func _ready():
	food = initial_food
	get_node("Label").set_text(str(food))
	pass

func _on_Beach_input_event( viewport, event, shape_idx ):
	if (food > 0):
		if (event.type==InputEvent.MOUSE_BUTTON and event.pressed):
			get_parent().add_food()
			food -= 1
			get_node("Label").set_text(str(food))
