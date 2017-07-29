extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
enum game_state { DAY, NIGHT }
var state

export var night_duration = 5.0
var night_accum

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	state = game_state.DAY
	night_accum = 0
	set_process(true)
	
func _process(delta):
	if (state == game_state.NIGHT):
		night_accum += delta
		if (night_accum >= night_duration):
			print("DAY")
			state = game_state.DAY
		
func on_click():
	if (state == game_state.DAY):
		print("NIGHT")
		night_accum = 0
		state = game_state.NIGHT
