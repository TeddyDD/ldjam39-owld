extends Node2D

signal player_in_house(state)
var deployed = false
var max_asc_speed = 50
var max_desc_speed = 50
var cooldown = 2
var speed = 0

func _ready():
	set_process(true)
	
func _process(delta):
	if speed > -max_desc_speed:
		speed -= rand_range(cooldown/2, cooldown) * delta


func _on_Area2D_area_enter( area ):
	if area.is_in_group("player"):
		get_node("wall animation").play("hide_wall")
		emit_signal("player_in_house", true)

func _on_Area2D_area_exit( area ):
	if area.is_in_group("player"):
		get_node("wall animation").play("show_wall")
		emit_signal("player_in_house", false)
