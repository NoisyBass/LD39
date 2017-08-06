extends Area2D

export var regen_days = 2
var initial_wood = 3
var wood = 0
var trees = []
onready var label = get_node("../PickWood")

func _ready():
	wood = initial_wood
	for i in range(initial_wood):
		trees.append(get_node("Tree_" + str(i)))
		
	for tree in trees:
		tree.set_regen_days(regen_days)

func _on_Forest_input_event( viewport, event, shape_idx ):
	if (get_parent().is_day() and wood > 0):
		if (event.type==InputEvent.MOUSE_BUTTON and event.pressed):
			set_process(false)
			label.hide()
			get_parent().add_wood()
			trees[wood-1].cut()
			get_node("SamplePlayer").play("Chopping wood")
			add_wood(-1)

func regenerate_tree():
	add_wood(1)

func add_wood(amount):
	wood += amount

func day_finished():
	for tree in trees:
		if (tree.is_regenerating()):
			tree.day_finished()
			


func _on_Forest_mouse_enter():
	if (get_parent().is_day()):
		set_process(true)
		label.show()


func _on_Forest_mouse_exit():
	set_process(false)
	label.hide()
	
func _process(delta):
	var pos = get_viewport().get_mouse_pos()
	pos.x += 10
	pos.y -= 10
	label.set_pos(pos)
