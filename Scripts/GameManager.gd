extends Node2D

enum game_state { DAY, NIGHT }
var state

export var night_duration = 5.0
var night_accum
export var nights_to_win = 3
var current_nights

var wood = 0 setget set_wood, get_wood
onready var wood_label = get_node("Wood")
var food = 0 setget set_food, get_food
onready var food_label = get_node("Food")

var sanity = 100 setget set_sanity, get_sanity
export var sanity_mul = [-2, -1, 0, 1]
export var sanity_inc_dec = 0.5
onready var sanity_bar = get_node("Sanity")

var hunger = 100 setget set_hunger, get_hunger
export var hunger_dec_time = 5
export var hunger_dec_kindle = 10
export var hunger_inc_eat = 10
onready var hunger_bar = get_node("Hunger")

var song_pos = 0

func _ready():
	state = game_state.DAY
	night_accum = 0
	current_nights = 0
	wood_label.set_text(str(wood))
	food_label.set_text(str(wood))
	set_process(true)
	get_node("JunglePlayer").play()
	get_node("Player/PlayerAnim").play("player_idle")

func _process(delta):
	if (state == game_state.NIGHT):
		night_accum += delta
		if (night_accum >= night_duration):
			current_nights += 1
			if (current_nights == nights_to_win):
				get_node("/root/Global").goto_scene("res://Scenes/YouWin.tscn")
			set_day()
		else:
			set_hunger(hunger - delta * hunger_dec_time)
			var fire_level = get_node("FireManager").get_fire_level()
			set_sanity(sanity + delta * sanity_inc_dec*sanity_mul[fire_level])

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

func set_day():
	print('SET DAY')
	var animator = get_node("Fade/AnimationPlayer")
	animator.play("Fade")

	var timer = get_node("Timer")
	timer.set_wait_time(animator.get_current_animation_length() / 2)
	timer.connect("timeout", sanity_bar, "hide", [],
	              CONNECT_ONESHOT)
	timer.connect("timeout", hunger_bar, "hide", [],
	              CONNECT_ONESHOT)
	timer.connect("timeout", get_node("FireManager"), "day_comes",
	              [], CONNECT_ONESHOT)
	timer.connect("timeout", get_node("Forest"), "day_finished",
	              [], CONNECT_ONESHOT)
	timer.connect("timeout", get_node("Beach"), "day_finished",
	              [], CONNECT_ONESHOT)
	timer.connect("timeout", get_node("Eyes"), "hide",
	              [], CONNECT_ONESHOT)
	timer.connect("timeout", get_node("JunglePlayer"), "play", [],
	              CONNECT_ONESHOT)
	timer.connect("timeout", get_node("StreamPlayer"), "stop", [],
	              CONNECT_ONESHOT)
	timer.start()
	var tween = get_node("Tween")
	tween.interpolate_method(get_node("StreamPlayer"), "set_volume", 1, 0,
	                         animator.get_current_animation_length(),
	                         0, 2)
	tween.start()
	song_pos = get_node("StreamPlayer").get_pos()
	state = game_state.DAY

func set_night():
	var animator = get_node("Fade/AnimationPlayer")
	animator.play("Fade")
	night_accum = 0
	state = game_state.NIGHT

	var timer = get_node("Timer")
	timer.set_wait_time(animator.get_current_animation_length() / 2)
	timer.connect("timeout", sanity_bar, "show", [],
	              CONNECT_ONESHOT)
	timer.connect("timeout", hunger_bar, "show", [],
	              CONNECT_ONESHOT)
	timer.connect("timeout", get_node("FireManager"), "night_comes", [],
	              CONNECT_ONESHOT)
	timer.connect("timeout", get_node("Eyes"), "show", [],
	              CONNECT_ONESHOT)
	timer.connect("timeout", get_node("JunglePlayer"), "stop", [],
	              CONNECT_ONESHOT)
	get_node("StreamPlayer").set_volume(0)
	get_node("StreamPlayer").play(song_pos)
	var tween = get_node("Tween")
	tween.interpolate_method(get_node("StreamPlayer"), "set_volume", 0, 1,
	                         animator.get_current_animation_length(),
	                         0, 2)
	tween.start()
	timer.start()

# Wood get/set
func set_wood(value):
	if (value < wood):
		set_hunger(hunger - hunger_dec_kindle)
	wood = value
	wood_label.set_text(str(wood))

func get_wood():
	return wood
	
# Food get/set
func set_food(value):
	if (value < food):
		set_hunger(hunger + hunger_inc_eat)
	food = value
	food_label.set_text(str(food))

func get_food():
	return food

# Sanity get/set
func set_sanity(value):
	sanity = value
	sanity_bar.set_value(sanity)
	
	if (sanity < 0):
		get_node("/root/Global").goto_scene("res://Scenes/GameOver.tscn")

func get_sanity():
	return sanity
	
# Hunger get/set
func set_hunger(value):
	hunger = value
	hunger_bar.set_value(hunger)
	
	if (hunger < 0):
		get_node("/root/Global").goto_scene("res://Scenes/GameOver.tscn")

func get_hunger():
	return hunger
	
func is_day():
	return state == game_state.DAY