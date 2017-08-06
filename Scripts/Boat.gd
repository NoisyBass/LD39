extends Area2D

# class member variables go here, for example:
var level
onready var label = get_node("../FixBoat")
onready var sprite = get_node("Sprite")
var boat = [preload("res://Assets/Graphics/boat_0.png"), 
            preload("res://Assets/Graphics/boat_1.png"),
            preload("res://Assets/Graphics/boat_2.png"),
            preload("res://Assets/Graphics/boat_3.png")]

func _ready():
	level = 0
	sprite.set_texture(boat[level])

func _on_Boat_input_event( viewport, event, shape_idx ):
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed and
	    get_parent().wood and get_parent().is_day()):
			get_parent().dec_wood()
			level += 1
			sprite.set_texture(boat[level])
			label.hide()
			if (level == 3):
				var t = Timer.new()
				t.set_wait_time(2)
				t.set_one_shot(true)
				self.add_child(t)
				t.start()
				yield(t, "timeout")
				get_node("/root/Global").goto_scene("res://Scenes/YouWin.tscn")


func _on_Boat_mouse_enter():
	if (get_parent().is_day() && get_parent().wood):
		set_process(true)
		label.show()


func _on_Boat_mouse_exit():
	set_process(false)
	label.hide()
	
func _process(delta):
	var pos = get_viewport().get_mouse_pos()
	pos.x += 10
	pos.y -= 10
	label.set_pos(pos)
