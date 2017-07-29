extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var animator

func _ready():
	animator = get_node("AnimationPlayer")
	animator.play("Low Fire")

func kindle():
	animator.play("Medium Fire")

# Just for testing
func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed):
		print('Kindeling')
		animator.stop()
		kindle()
