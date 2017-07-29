extends CanvasModulate

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_home_player_in_house( state ):
	if state == true:
		get_node("weather anim").play("go inside")
	else:
		get_node("weather anim").play("go outside")
