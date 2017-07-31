extends Node2D

onready var anim = get_node("AnimationPlayer")
onready var text = get_node("text")
onready var timer = get_node("timeout")

signal done

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func say(what, timeout=3):
	if get_parent().get_node("FSM2D").getStateID() == "dead":
		text.set_text("")
		return
	text.set_text(what)
	anim.play("show")
	timer.set_wait_time(timeout)
	
func start_timer():
	timer.start()
	
func can_speak():
	emit_signal("done")

func _on_timeout_timeout():
	anim.play("hide")
