extends Node2D

export(Texture) var day_fire
export var night_fire_anims = ["Low Fire", "Medium Fire",
                               "High Fire", "Max Fire"]
export var night_fire_timeouts = [60, 40, 30, 15]
var animator
var fire_sprite
var since_last_kindle

func _ready():
	animator = get_node("AnimationPlayer")
	animator.play(night_fire_anims[0])
	set_process(true)
	since_last_kindle = 0

func _process(delta):
	since_last_kindle += delta
	unkindle()

func kindle():
	var idx = night_fire_anims.find(animator.get_current_animation())
	if idx + 1 < night_fire_anims.size():
		animator.play(night_fire_anims[idx + 1])
	else:
		print("Fire at max")
	since_last_kindle = 0

func unkindle():
	var idx = night_fire_anims.find(animator.get_current_animation())
	if (idx > 0 and since_last_kindle >= night_fire_timeouts[idx]):
		animator.play(night_fire_anims[idx - 1])

func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed and
	    get_parent().wood):
		if animator.get_current_animation() != night_fire_anims[-1]:
			get_parent().wood = get_parent().wood - 1
			kindle()
