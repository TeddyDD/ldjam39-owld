extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_play_button_down():
	get_tree().change_scene("res://game.tscn") 


func _on_ldjam_button_down():
	OS.shell_open("https://ldjam.com/events/ludum-dare/39")
