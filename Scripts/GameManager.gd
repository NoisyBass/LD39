extends Node2D

enum game_state { DAY, NIGHT }
var state

export var night_duration = 5.0
var night_accum

var wood = 0 setget set_wood, get_wood
onready var wood_label = get_node("Wood")
var food = 0 setget set_food, get_food
onready var food_label = get_node("Food")

var sanity = 100 setget set_sanity, get_sanity
export var sanity_factor = 5
export var sanity_inc = 10
onready var sanity_bar = get_node("Sanity")

var hunger = 100 setget set_hunger, get_hunger
export var hunger_factor = 5
export var hunger_inc = 10
onready var hunger_bar = get_node("Hunger")

func _ready():
	state = game_state.DAY
	night_accum = 0
	wood_label.set_text("Wood: " + str(wood))
	food_label.set_text("Food: " + str(wood))
	set_process(true)

func _process(delta):
	if (state == game_state.NIGHT):
		night_accum += delta
		if (night_accum >= night_duration):
			set_day()
		else:
			set_hunger(hunger - delta * hunger_factor)

func add_wood():
	if (state == game_state.DAY):
		set_night()
		set_wood(wood + 1)

func add_food():
	if (state == game_state.DAY):
		set_night()
		set_food(food + 1)
		
func dec_food():
	if (state == game_state.NIGHT):
		set_food(food - 1)
		set_hunger(hunger + hunger_inc)

func set_day():
	var animator = get_node("Fade/AnimationPlayer")
	animator.play("Fade")

	var timer = get_node("Timer")
	var fade_half_len = animator.get_current_animation_length() / 2
	timer.set_wait_time(fade_half_len)
	timer.connect("timeout", sanity_bar, "hide", [],
	              CONNECT_ONESHOT)
	timer.connect("timeout", hunger_bar, "hide", [],
	              CONNECT_ONESHOT)
	timer.start()

	get_node("Forest").day_finished()
	get_node("Beach").day_finished()
	get_node("FireManager").day_comes()
	state = game_state.DAY
	get_node("TIME").set_text("DAY")

func set_night():
	var animator = get_node("Fade/AnimationPlayer")
	animator.play("Fade")
	get_node("FireManager").night_comes()
	night_accum = 0
	state = game_state.NIGHT
	get_node("TIME").set_text("NIGHT")

	var timer = get_node("Timer")
	var fade_half_len = animator.get_current_animation_length() / 2
	timer.set_wait_time(fade_half_len)
	timer.connect("timeout", sanity_bar, "show", [],
	              CONNECT_ONESHOT)
	timer.connect("timeout", hunger_bar, "show", [],
	              CONNECT_ONESHOT)
	timer.start()

# Wood get/set
func set_wood(value):
	wood = value
	wood_label.set_text("Wood: " + str(wood))

func get_wood():
	return wood
	
# Food get/set
func set_food(value):
	food = value
	food_label.set_text("Food: " + str(food))

func get_food():
	return food
	
# Sanity get/set
func set_sanity(value):
	sanity = value
	sanity_bar.set_value(sanity)

func get_sanity():
	return sanity
	
# Hunger get/set
func set_hunger(value):
	hunger = value
	hunger_bar.set_value(hunger)

func get_hunger():
	return hunger
	
func is_day():
	return state == game_state.DAY