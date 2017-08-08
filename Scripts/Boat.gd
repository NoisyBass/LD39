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
			level += 1
			get_parent().dec_wood()
			sprite.set_texture(boat[level])
			get_node("SamplePlayer").play("Boat")
			label.hide()
			if (is_complete()):
				get_node("../Player/PlayerAnim").play("player_win")
				var t = Timer.new()
				t.set_wait_time(3)
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
	
func is_complete():
	return level == 3
