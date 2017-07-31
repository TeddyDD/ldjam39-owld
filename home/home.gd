extends Node2D

signal player_in_house(state)
var deployed = false
var max_asc_speed = 50
var max_desc_speed = 50
var cooldown = 2
var speed = 50

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	get_node("fire").set_amount(lerp(0,64, (speed+50)/100))
	if speed > -max_desc_speed:
		speed -= rand_range(cooldown/2, cooldown) * delta
	if deployed:
		set_pos(get_pos() + Vector2(0, -speed) * delta)
	speed = clamp(speed, -max_desc_speed, max_asc_speed)
		
# run from animation
func deploy():
	speed = max_asc_speed
	deployed = true


func _on_Area2D_area_enter( area ):
	if area.is_in_group("player"):
		if not deployed:
			get_node("deploy").play("deploy")
		get_node("wall animation").play("hide_wall")
		emit_signal("player_in_house", true)

func _on_Area2D_area_exit( area ):
	if area.is_in_group("player"):
		get_node("wall animation").play("show_wall")
		emit_signal("player_in_house", false)
