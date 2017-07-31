extends Node2D


export(Texture) var day_fire
export var night_anims = ["Low Fire", "Medium Fire",
                          "High Fire", "Max Fire"]
export var night_timeouts = [60, 40, 30, 15]

onready var animator = get_node("AnimationPlayer")
onready var fire_sprite = get_node("Sprite")
onready var light = get_node("Light2D")
var since_last_kindle

func _ready():
	set_process(true)
	day_comes()
	since_last_kindle = 0

func _process(delta):
	since_last_kindle += delta
	unkindle()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed and
	    get_parent().wood and
	    animator.get_current_animation() != night_anims[-1]):
			get_parent().wood -= 1
			kindle()

func night_comes():
	animator.play(night_anims[0])
	light.set_scale(Vector2(1, 1))
	light.show()

func day_comes():
	animator.stop()
	fire_sprite.set_texture(day_fire)
	light.hide()

func kindle():
	var idx = night_anims.find(animator.get_current_animation())
	if idx + 1 < night_anims.size():
		animator.play(night_anims[idx + 1])
		light.scale(Vector2(1.2, 1.2))
	else:
		print("Fire at max")
	since_last_kindle = 0

func unkindle():
	var idx = night_anims.find(animator.get_current_animation())
	if idx > 0 and since_last_kindle >= night_timeouts[idx]:
		animator.play(night_anims[idx - 1])
		light.scale(Vector2(0.8, 0.8))
