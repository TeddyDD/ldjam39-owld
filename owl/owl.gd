extends KinematicBody2D

var velocity = Vector2()
var last_collision = null
enum { DIR_LEFT, DIR_RIGHT }
var direction = DIR_RIGHT
var WALK_SPEED = 150


func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	velocity.y += global.gravity.y * delta

func standard_update(delta):
	var motion = velocity * delta
	move(motion)
	if (is_colliding()):
		var n = get_collision_normal()
		last_collision = n
#		get_node("debug").set_text("%s" % rad2deg(n.floor().angle()))
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
		
func sideways_movement(delta):
	velocity.x = velocity.x * 0.5 
	if Input.is_action_pressed("ui_left"):
		velocity.x += -WALK_SPEED
	if Input.is_action_pressed("ui_right"):
		velocity.x += WALK_SPEED
	
	if velocity.x > 0:
		direction = DIR_RIGHT
	elif velocity.x < 0:
		direction = DIR_LEFT

func _on_FSM2D_stateChanged( newStateID, oldStateID ):
	prints(newStateID)