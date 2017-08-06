extends Sprite

# class member variables go here, for example:
onready var label = get_node("../Eat")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_Area2D_input_event( viewport, event, shape_idx ):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed and
	    get_parent().food):
			get_parent().dec_food()
			label.hide()


func _on_Area2D_mouse_enter():
	if ((not get_parent().is_day()) && get_parent().food > 0):
		label.show()


func _on_Area2D_mouse_exit():
	label.hide()
