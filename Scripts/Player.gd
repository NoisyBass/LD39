extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_Area2D_input_event( viewport, event, shape_idx ):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed and
	    get_parent().food):
			get_parent().food -= 1
