extends Sprite

var regen_days
var regen_accum
var regenerating

func _ready():
	regenerating = false
	pass
	
func set_regen_days(days):
	regen_days = days
	
func cut():
	regenerating = true
	regen_accum = 0
	
func day_finished():
	if (regenerating):
		regen_accum += 1
		if (regen_accum == regen_days):
			regenerating = false
			get_parent().regenerate_tree()
			
func is_regenerating():
	return regenerating
	
