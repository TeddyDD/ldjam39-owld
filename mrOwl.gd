extends KinematicBody2D

var sm = preload("res://fsm.gd")
onready var fsm = sm.new()
var current_state = null

var WALK_SPEED = 300
var SLOW_DOWN = 300
var MAX_X_SPEED = 350
var Y_SPEED = 250
var last_collision = null
var velocity = Vector2()

enum { DIR_LEFT, DIR_RIGHT }
var direction = DIR_RIGHT setget set_direction

func _ready():
	fsm.add_group("ground")
	fsm.add_group("air")
	
	fsm.add_state("idle", null, "ground")
	fsm.add_state("move", null, "ground")
	fsm.add_state("fly_up", null, "air")
	fsm.add_state("fly", null, "air")
	
	fsm.add_link("idle", "move", "condition",\
	             [self, "is_moving", true])  # walk
	fsm.add_link("move", "idle", "condition",\
	             [self, "is_moving", false]) # stop
	fsm.add_link("ground", "fly_up", "condition",\
	             [self, "is_flaping", true])
	fsm.add_link("fly", "fly_up", "timed condition",\
	             [1, self, "is_flaping", true])
	fsm.add_link("fly_up", "fly", "condition",\
	             [self, "y_max_speed", true])
	fsm.add_link("air", "idle", "condition",\
	             [self, "is_on_the_ground", true])
	fsm.connect("state_changed",self,"on_state_changed")
	set_fixed_process(true)
	fsm.set_state("fly")

########### 
# Process #
###########

func _fixed_process(delta):
	get_node("debug").set_text(str(velocity.x, " XXX ", velocity.y))
	fsm.process(delta)
	
	if current_state == "fly_up":
		if Input.is_action_pressed("ui_up"):
			velocity.y -= Y_SPEED
#			assert(velocity.y <= -Y_SPEED)
#			fsm.set_state("fly")
	velocity.y += global.gravity.y * delta
	
	# left - rigt movement
	velocity = process_move(delta, velocity)
	
	velocity.x = clamp(velocity.x, -MAX_X_SPEED, MAX_X_SPEED)
	velocity.y = clamp(velocity.y, -Y_SPEED, global.gravity.y)
	
	var motion = velocity * delta
	move(motion)
	if (is_colliding()):
		var n = get_collision_normal()
		last_collision = n
#		get_node("debug").set_text("%s" % rad2deg(n.floor().angle()))
		motion = n.slide(motion)
		velocity = n.slide(velocity)
		move(motion)
	else:
		last_collision = null
	
	if abs(velocity.x) < SLOW_DOWN + 10:
		velocity.x = 0
	elif direction == DIR_RIGHT:
		velocity.x -= SLOW_DOWN * delta
	elif direction == DIR_LEFT:
		velocity.x += SLOW_DOWN * delta
	

func process_move(delta, velocity):
	if Input.is_action_pressed("ui_left"):
		velocity.x += -WALK_SPEED
	if Input.is_action_pressed("ui_right"):
		velocity.x += WALK_SPEED
	
	if velocity.x < 0:
		direction = DIR_LEFT
	elif velocity.x > 0:
		direction = DIR_RIGHT
	
	return velocity

#############
# SIGNALS   #
#############
	
func on_state_changed(from, to, args):
	current_state = to
	prints(to)
	
##########
# setget #
##########

# TODO set sprite direction
func set_direction(value):
	direction = value

##################
# FSM Conditions #
##################

# flying
func is_flaping():
	return Input.is_action_pressed("ui_up")

func y_max_speed():
	return velocity.y <= -Y_SPEED

func is_on_the_ground():
	if last_collision != null:
		if last_collision.floor().x == 0 and\
		   last_collision.floor().y == -1:
			return true
	return false
	

# move on the ground?
func is_moving():
	return Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")
