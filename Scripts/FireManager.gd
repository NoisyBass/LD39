extends Node2D


export(Texture) var day_fire
export var night_anims = ["Low Fire", "Medium Fire",
                          "High Fire", "Max Fire"]
export var night_timeouts = [60, 40, 30, 15]

onready var animator = get_node("AnimationPlayer")
onready var fire_sprite = get_node("Sprite")
onready var light = get_node("Light2D")
onready var player = get_node("SamplePlayer2D")
onready var label = get_node("../Kindle")
var since_last_kindle
var fire_voice

func _ready():
	set_process(true)
	day_comes()
	since_last_kindle = 0

func _process(delta):
	since_last_kindle += delta
	unkindle()

	var f = 0.005*sin(OS.get_ticks_msec()*5)
	var scale = light.get_scale()
	light.set_scale(Vector2(scale.x + f, scale.y + f))

func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed and
	    get_parent().wood and
	    animator.get_current_animation() != night_anims[-1] and
		not get_parent().is_day()):
			get_parent().wood -= 1
			kindle()

func night_comes():
	animator.play(night_anims[0])
	light.set_scale(Vector2(1.1, 1.1))
	light.show()
	get_node("StreamPlayer").play()

func day_comes():
	animator.stop()
	fire_sprite.set_hframes(1)
	fire_sprite.set_frame(0)
	fire_sprite.set_texture(day_fire)
	light.hide()
	player.stop_all()
	get_node("StreamPlayer").stop()

func get_fire_level():
	return night_anims.find(animator.get_current_animation())

func kindle():
	var idx = night_anims.find(animator.get_current_animation())
	if idx + 1 < night_anims.size():
		animator.play(night_anims[idx + 1])
		light.scale(Vector2(1.2, 1.2))
		since_last_kindle = 0
		player.play("Kindle")
		get_node("StreamPlayer").set_volume(get_node("StreamPlayer").get_volume() + 3)
		label.hide()
	else:
		print("Fire at max")

func unkindle():
	var idx = night_anims.find(animator.get_current_animation())
	if (idx > 0 and since_last_kindle >= night_timeouts[idx] and
	    not get_parent().is_day()):
		animator.play(night_anims[idx - 1])
		light.scale(Vector2(0.8, 0.8))
		get_node("StreamPlayer").set_volume(get_node("StreamPlayer").get_volume() - 3)


func _on_Area2D_mouse_enter():
	if ((not get_parent().is_day()) && get_parent().wood):
		label.show()

func _on_Area2D_mouse_exit():
	label.hide()
