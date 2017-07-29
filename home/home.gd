extends Node2D

signal player_in_house(state)
var deployed = false

func _ready():
	pass


func _on_Area2D_area_enter( area ):
	if area.is_in_group("player"):
		get_node("wall animation").play("hide_wall")
		emit_signal("player_in_house", true)

func _on_Area2D_area_exit( area ):
	if area.is_in_group("player"):
		get_node("wall animation").play("show_wall")
		emit_signal("player_in_house", false)
