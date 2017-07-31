
extends KinematicBody2D

var velocity = Vector2()
var last_collision = null
enum { DIR_LEFT, DIR_RIGHT }
var direction = DIR_RIGHT
var WALK_SPEED = 150
var in_house = false
var home = null

var hp = 100
var hp_regen = 35
var hp_los = 6
var hp_passive = 3

var carry_items = 0
signal dropItem(inArea)
var currentArea = null

var tween

var talk = {
	start = "Terrible weather",
	hp = {txt = "I can rest inside", said = false},
	better = {txt = "Much better", said = false},
	ouch = { txt = "Ouch!", said = false },
	get = { txt = """Ballon is leaking, furnace is old...
	I can use wooden flying debris as fuel
	to keep my house in the air.""",  said = false}
}

func say(what):
	if not talk[what].said:
		get_node("say").say(talk[what].txt)
		talk[what].said = true

func _ready():
	set_fixed_process(true)
	tween = get_node("Tween")
	home = get_tree().get_nodes_in_group("home")[0]
#	get_node("say").say(talk["start"])
	
func _fixed_process(delta):
	velocity.y += global.gravity.y * delta
	
	
	# talking
	if not talk.hp.said and hp < 60:
		talk.hp.said = true
		get_node("say").say(talk.hp.txt)
	
	if not in_house:
		get_node("home arrow").set_rot((home.get_pos() - get_pos()).angle())
	else:
		if currentArea != null:
			if Input.is_action_pressed("ui_accept"):
				carry_items = 0
				emit_signal("dropItem", currentArea)
	

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
		
func sideways_movement(delta, walkSpeed=WALK_SPEED):
	velocity.x = velocity.x * 0.5 
	if Input.is_action_pressed("ui_left") and get_global_pos().x > -1200:
		velocity.x += -walkSpeed
	if Input.is_action_pressed("ui_right") and get_global_pos().x < 1200:
		velocity.x += walkSpeed
	
	if velocity.x > 0:
		direction = DIR_RIGHT
		get_node("Sprite").set_flip_h(false)
		get_node("carry").set_scale(Vector2(1,1))
	elif velocity.x < 0:
		direction = DIR_LEFT
		get_node("Sprite").set_flip_h(true)
		get_node("carry").set_scale(Vector2(-1,1))

func _on_FSM2D_stateChanged( newStateID, oldStateID ):
#	prints(newStateID)
	pass


func _on_home_player_in_house( state ):
	in_house = state
	var c = get_node("Camera2D")
	if in_house:
		get_node("home arrow").hide()
		tween.stop(c, "zoom")
		tween.interpolate_property(c,\
		"zoom", c.get("zoom"), Vector2(0.6,0.6), 1, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()
	else:
		tween.stop(c, "zoom")
		tween.interpolate_property(c,\
		"zoom", c.get("zoom"), Vector2(1,1), 0.7, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()
		get_node("home arrow").show()
		


func _on_player_area_area_enter( area ):
	if area.is_in_group("fuel_drop"):
		currentArea = area


func _on_player_area_area_exit( area ):
	if area.is_in_group("fuel_drop"):
		currentArea = null
