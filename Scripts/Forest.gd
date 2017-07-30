extends Area2D

export var regen_days = 2
var initial_wood = 3
var wood = 0
var trees = []

func _ready():
	wood = initial_wood
	trees.append(get_node("Tree_" + str(0)))
	trees.append(get_node("Tree_" + str(1)))
	trees.append(get_node("Tree_" + str(2)))
	
	for tree in trees:
		tree.set_regen_days(regen_days)
		
	get_node("Label").set_text(str(wood))
	pass

func _on_Forest_input_event( viewport, event, shape_idx ):
	if (get_parent().is_day() and wood > 0):
		if (event.type==InputEvent.MOUSE_BUTTON and event.pressed):
			get_parent().add_wood()
			trees[wood-1].cut()
			add_wood(-1)
			
func regenerate_tree():
	add_wood(1)
	
func add_wood(amount):
	wood += amount
	get_node("Label").set_text(str(wood))
	
func day_finished():
	for tree in trees:
		if (tree.is_regenerating()):
			tree.day_finished()
