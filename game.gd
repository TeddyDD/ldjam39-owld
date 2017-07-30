extends Node2D

var fuel = preload("res://flying objects/fuel.tscn")

func _ready():
	set_process(true)
	
func _process(delta):
	get_node("ui/hp bar").set_value(get_node("owl").hp)


func _on_fuel_spawner_timeout():
	var f = fuel.instance()
	# spawn position
	var p = Vector2()
	# spawn velocity vector
	var v = Vector2(0,-35)
	if randi() % 2 == 0: #left
		p = get_viewport_rect().pos + Vector2(-10, 0)
		v.x = 200
	else: # right
		p = get_viewport_rect().pos + get_viewport_rect().size + Vector2(10, 0)
		p.y = get_viewport_rect().pos.y
		v.x = -200
	f.set_pos(p)
	f.velocity = v
	add_child(f)
	get_node("fuel spawner").start()
