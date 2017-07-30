extends Node

var animator
var since_last_kindle
export var animations = ["Low Fire", "Medium Fire", "High Fire", "Max Fire"]
export var timeouts = [60, 40, 30, 15]

func _ready():
	animator = get_node("AnimationPlayer")
	animator.play(animations[0])
	set_process(true)
	since_last_kindle = 0

func _process(delta):
	since_last_kindle += delta
	unkindle()

func kindle():
	var idx = animations.find(animator.get_current_animation())
	if idx + 1 < animations.size():
		animator.play(animations[idx + 1])
	else:
		print("Fire at max")
	since_last_kindle = 0

func unkindle():
	var idx = animations.find(animator.get_current_animation())
	if (idx > 0 and since_last_kindle >= timeouts[idx]):
		animator.play(animations[idx - 1])

# Just for testing
func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed):
		kindle()
