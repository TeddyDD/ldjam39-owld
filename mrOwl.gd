extends KinematicBody2D

var sm = preload("res://fsm.gd")
onready var fsm = sm.new()
var current_state = null

export var WALK_SPEED = 300
var velocity = Vector2()

func _ready():
	fsm.add_state("idle")
	fsm.add_state("move")
	fsm.add_state("fly_up")
	fsm.add_state("fly_down")
	
	fsm.add_link("idle", "move", "condition",\
	             [self, "is_moving", true])  # walk
	fsm.add_link("move", "idle", "condition",\
	             [self, "is_moving", false]) # stop
	fsm.connect("state_changed",self,"on_state_changed")
	set_fixed_process(true)
	fsm.set_state("idle")

########### 
# Process #
###########

func _fixed_process(delta):
	fsm.process(delta)
	velocity = Vector2()
	velocity.y = global.gravity.y
	if current_state == "move":
		velocity = process_move(delta, velocity)
	
		
	var motion = velocity * delta
	move(motion)
	if (is_colliding()):
		var n = get_collision_normal()
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)

func process_move(delta, velocity):
	if Input.is_action_pressed("ui_left"):
		velocity.x += -WALK_SPEED
	if Input.is_action_pressed("ui_right"):
		velocity.x += WALK_SPEED
	return velocity

#############
# SIGNALS   #
#############
	
func on_state_changed(from, to, args):
	current_state = to
	prints(to)

##################
# FSM Conditions #
##################

# move on the ground?
func is_moving():
	return Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")
