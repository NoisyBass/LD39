extends Node

var animator
var since_last_kindle
var animations = ["Low Fire", "Medium Fire", "High Fire", "Max Fire"]
var timeouts = [60, 40, 30, 15]

func _ready():
	animator = get_node("AnimationPlayer")
	animator.play(animations[0])
	set_process(true)
	since_last_kindle = 0

func _process(delta):
	since_last_kindle += delta

func kindle():
	var idx = animations.find(animator.get_current_animation())
	if idx + 1 < animations.size():
		animator.play(animations[idx + 1])
	else:
		print("Fire at max")
	since_last_kindle = 0

func unkindle():
	if (since_last_kindle >= 20 and
	    animator.get_current_animation() == "Max Fire"):
		animator.play("High Fire")
	

# Just for testing
func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed):
		kindle()
