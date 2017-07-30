extends Node2D

var fuel = preload("res://flying objects/fuel.tscn")

func _ready():
	set_process(true)
	
func _process(delta):
	get_node("ui/hp bar").set_value(get_node("owl").hp)
	
	get_node("ui/ascend bar").set_min(-get_node("home").max_desc_speed)
	get_node("ui/ascend bar").set_max(get_node("home").max_asc_speed)
	get_node("ui/ascend bar").set_value(get_node("home").speed)


func _on_fuel_spawner_timeout():
	var f = fuel.instance()
	# spawn position
	var p = Vector2(get_node("owl/spawner").get_global_pos()\
	+ Vector2(rand_range(-300,300),0))
#	prints(p)
	# spawn velocity vector
	var v = (get_node("owl").get_pos() - p) + Vector2(rand_range(-100,100), rand_range(-50,0))
	f.velocity = v
	add_child(f)
	f.set_pos(p)
	
	get_node("fuel spawner").start()
