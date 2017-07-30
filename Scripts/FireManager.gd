extends Node2D

export(Texture) var day_fire
export var night_fire_anims = ["Low Fire", "Medium Fire",
                               "High Fire", "Max Fire"]
export var night_fire_timeouts = [60, 40, 30, 15]

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
	    self.get_parent().wood):
		if (self.animator.get_current_animation() !=
		    self.night_fire_anims[-1]):
			self.get_parent().wood = self.get_parent().wood - 1
			self.kindle()

func night_comes():
	self.animator.play(night_fire_anims[0])

func day_comes():
	self.animator.stop()
	self.fire_sprite.set_texture(self.day_fire)

func kindle():
	var idx = night_fire_anims.find(animator.get_current_animation())
	if idx + 1 < night_fire_anims.size():
		self.animator.play(self.night_fire_anims[idx + 1])
	else:
		print("Fire at max")
	self.since_last_kindle = 0

func unkindle():
	var idx = night_fire_anims.find(animator.get_current_animation())
	if (idx > 0 and
	    self.since_last_kindle >= night_fire_timeouts[idx]):
		self.animator.play(self.night_fire_anims[idx - 1])
