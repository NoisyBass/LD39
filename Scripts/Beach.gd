extends Area2D

export var regen_time = 2
var initial_food = 3
var food = 0

func _ready():
	food = initial_food
	get_node("Label").set_text(str(food))
	pass

func _on_Beach_input_event( viewport, event, shape_idx ):
	if (get_parent().is_day() and food > 0):
		if (event.type==InputEvent.MOUSE_BUTTON and event.pressed):
			get_parent().add_food()
			add_food(-1)
			
func regenerate_food():
	add_food(1)
	
func add_food(amount):
	food += amount
	get_node("Label").set_text(str(food))
	
func day_finished():
	#for tree in trees:
	#	if (tree.is_regenerating()):
	#		tree.day_finished()
	pass
