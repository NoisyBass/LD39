extends Node2D

enum game_state { DAY, NIGHT }
var state

export var night_duration = 5.0
var night_accum

var wood = 0 setget set_wood, get_wood
var food = 0 setget set_food, get_food
var fear
var hunger

func _ready():
	state = game_state.DAY
	night_accum = 0
	update_values()
	set_process(true)

func _process(delta):
	if (state == game_state.NIGHT):
		night_accum += delta
		if (night_accum >= night_duration):
			set_day()

func add_wood():
	if (state == game_state.DAY):
		set_night()
		wood += 1
		update_values()

func add_food():
	if (state == game_state.DAY):
		set_night()
		food += 1
		update_values()

func set_day():
	print("DAY")
	var animator = get_node("Fade/AnimationPlayer")
	animator.play("Fade")
	"""
	var timer = get_node("Timer")
	var fade_half_len = animator.get_current_animation_length() / 2
	timer.set_wait_time(fade_half_len)
	timer.connect("timeout", get_node("DayCycleTint"), "hide", [],
	              CONNECT_ONESHOT)
	timer.start()
	"""
	get_node("Forest").day_finished()
	get_node("Beach").day_finished()
	get_node("FireManager").day_comes()
	state = game_state.DAY
	get_node("TIME").set_text("DAY")

func set_night():
	print("NIGHT")
	var animator = get_node("Fade/AnimationPlayer")
	animator.play("Fade")
	get_node("FireManager").night_comes()
	night_accum = 0
	state = game_state.NIGHT
	get_node("TIME").set_text("NIGHT")
	"""
	var timer = get_node("Timer")
	var fade_half_len = animator.get_current_animation_length() / 2
	timer.set_wait_time(fade_half_len)
	timer.connect("timeout", get_node("DayCycleTint"), "show", [],
	              CONNECT_ONESHOT)
	timer.start()
	"""

func update_values():
	get_node("Wood").set_text("Wood: " + str(wood))
	get_node("Food").set_text("Food: " + str(food))

# Wood get/set
func set_wood(value):
	wood = value
	get_node("Wood").set_text("Wood: " + str(wood))

func get_wood():
	return wood
	
# Wood get/set
func set_food(value):
	food = value
	get_node("Food").set_text("Food: " + str(food))

func get_food():
	return food
	
func is_day():
	return state == game_state.DAY