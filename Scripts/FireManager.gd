extends Node2D

export(Texture) var day_fire
export var night_anims = ["Low Fire", "Medium Fire",
                               "High Fire", "Max Fire"]
export var night_timeouts = [60, 40, 30, 15]

onready var animator = get_node("AnimationPlayer")
onready var fire_sprite = get_node("Sprite")
var since_last_kindle

func _ready():
	set_process(true)
	self.day_comes()
	self.since_last_kindle = 0

func _process(delta):
	self.since_last_kindle += delta
	self.unkindle()

func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed and
	    self.get_parent().wood and
	    self.animator.get_current_animation() != self.night_anims[-1]):
			self.get_parent().wood -= 1
			self.kindle()

func night_comes():
	self.animator.play(night_anims[0])
	var light = get_node("Light2D")
	light.set_scale(Vector2(1, 1))
	light.show()

func day_comes():
	self.animator.stop()
	self.fire_sprite.set_texture(self.day_fire)
	get_node("Light2D").hide()

func kindle():
	var idx = night_anims.find(animator.get_current_animation())
	if idx + 1 < night_anims.size():
		self.animator.play(self.night_anims[idx + 1])
	else:
		print("Fire at max")
	self.since_last_kindle = 0

func unkindle():
	var idx = self.night_anims.find(self.animator.get_current_animation())
	if idx > 0 and self.since_last_kindle >= self.night_timeouts[idx]:
		self.animator.play(self.night_anims[idx - 1])
