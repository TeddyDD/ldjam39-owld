extends KinematicBody2D

var sm = preload("res://fsm.gd")
onready var fsm = sm.new()
var current_state = null

func _ready():
	fsm.add_state("idle")
	fsm.add_state("walk")
	fsm.add_state("fly_up")
	fsm.add_state("fly_down")
	
	fsm.add_link("idle", "move", "condition",\
	             [self, "is_moving", true])
	fsm.connect("state_changed",self,"on_state_changed")
	set_fixed_process(true)
	fsm.set_state("idle")
	
func state_changed(from, to, args):
	current_state = to
	
func is_moving():
	pass
