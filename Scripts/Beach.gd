extends Area2D

export var regen_days = 2
var initial_food = 3
var food = 0
var fishes = []
onready var label = get_node("../PickFood")

func _ready():
	food = initial_food
	for i in range(initial_food):
		fishes.append(get_node("Fish_" + str(i)))
		
	for fish in fishes:
		fish.set_regen_days(regen_days)

func _on_Beach_input_event( viewport, event, shape_idx ):
	if (get_parent().is_day() and food > 0):
		if (event.type == InputEvent.MOUSE_BUTTON and event.pressed):
			set_process(false)
			label.hide()
			get_parent().add_food()
			fishes[food-1].kill()
			add_food(-1)
			get_node("SamplePlayer").play("Splash")
	
func regenerate_food():
	add_food(1)

func add_food(amount):
	food += amount

func day_finished():
	for fish in fishes:
		if (fish.is_regenerating()):
			fish.day_finished()


func _on_Beach_mouse_enter():
	if (get_parent().is_day()):
		set_process(true)
		label.show()


func _on_Beach_mouse_exit():
	set_process(false)
	label.hide()
	
func _process(delta):
	var pos = get_viewport().get_mouse_pos()
	pos.x += 10
	pos.y -= 10
	label.set_pos(pos)
