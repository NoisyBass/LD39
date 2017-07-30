extends Sprite


var regen_days
var regen_accum
var regenerating

func _ready():
	regenerating = false
	pass
	
func set_regen_days(days):
	regen_days = days
	
func kill():
	regenerating = true
	hide()
	regen_accum = 0
	
func day_finished():
	if (regenerating):
		regen_accum += 1
		if (regen_accum == regen_days):
			regenerating = false
			show()
			get_parent().regenerate_food()
			
func is_regenerating():
	return regenerating
