extends Node2D

enum game_state { DAY, NIGHT }
var state

export var night_duration = 5.0
var night_accum

var wood = 0
var food = 0

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
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
	get_node("Fade/AnimationPlayer").play("Fade")
	state = game_state.DAY
	get_node("TIME").set_text("DAY")
	
func set_night():
	print("NIGHT")
	get_node("Fade/AnimationPlayer").play("Fade")
	night_accum = 0
	state = game_state.NIGHT
	get_node("TIME").set_text("NIGHT")
	
func update_values():
	get_node("Wood").set_text("Wood: " + str(wood))
	get_node("Food").set_text("Food: " +  str(food))
