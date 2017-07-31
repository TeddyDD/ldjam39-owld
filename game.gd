extends Node2D

var fuel = preload("res://flying objects/fuel.tscn")

var start_sequence = true

func _ready():
	set_process(true)
	
func _process(delta):
	get_node("ui/hp bar").set_value(get_node("owl").hp)
	
	get_node("ui/ascend bar").set_min(-get_node("home").max_desc_speed)
	get_node("ui/ascend bar").set_max(get_node("home").max_asc_speed)
	get_node("ui/ascend bar").set_value(get_node("home").speed)


func _on_fuel_spawner_timeout():
	var dist = get_node("owl").get_pos().distance_to(get_node("home").get_pos())

	for i in range(3):
		var f = fuel.instance()
		# spawn position
		var p = Vector2( get_node("home").get_global_pos().x,\
		                 get_node("owl/spawner").get_global_pos().y)\
		        + Vector2(rand_range(-1200, 1200), 0)
	
#		var p = Vector2( get_node("owl/spawner").get_pos().x + rand_range(-600,600),\
#		                 get_node("owl/spawner").get_global_mouse_pos().y - 700)
	
		# spawn velocity vector
		var v = Vector2(rand_range(-50,50), 0)
		f.velocity = v
		add_child(f)
		f.set_pos(p)
	
	get_node("fuel spawner").start()
	
	
	
# START SEQUENCE!!!

func start_setup():
	get_node("intro camera").make_current()

# one shoot signal
func _on_home_player_in_house( state ):
	# freeze player
	
	get_node("game start").play("start2_house")
	
#	get_node("owl/Camera2D").make_current()
