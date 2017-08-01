extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const MOTION_SPEED = 160 # Pixels/second
	
func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var motion = Vector2()
	
	if (Input.is_action_pressed("move_up")):
		motion += Vector2(0, -1)
	if (Input.is_action_pressed("move_bottom")):
		motion += Vector2(0, 1)
	if (Input.is_action_pressed("move_left")):
		motion += Vector2(-1, 0)
	if (Input.is_action_pressed("move_right")):
		motion += Vector2(1, 0)
	
	motion = motion.normalized()*MOTION_SPEED*delta
	move(motion)

func _on_Player_input_event( viewport, event, shape_idx ):
	print("click")
	if (event.type == InputEvent.MOUSE_BUTTON and event.pressed and
	    get_parent().food):
			get_parent().dec_food()
