extends Node2D

signal player_in_house(state)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_Area2D_area_enter( area ):
	if area.is_in_group("player"):
		get_node("AnimationPlayer").play("hide_wall")
		emit_signal("player_in_house", true)

func _on_Area2D_area_exit( area ):
	if area.is_in_group("player"):
		get_node("AnimationPlayer").play("show_wall")
		emit_signal("player_in_house", false)
