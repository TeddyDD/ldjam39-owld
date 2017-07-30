extends Node2D

var value = 50
var velocity = Vector2()
var vis_pos = get_pos()

func _ready():
	set_process(true)
