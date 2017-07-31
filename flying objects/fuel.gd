extends Node2D

var velocity = Vector2()
var player
var type = null

enum {POSITIVE, NEGATIVE}
var items = [
	{
		texture = "res://flying objects/krzeslo.png",
		broken = "res://flying objects/deski.png",
		type = POSITIVE
	},
	{
		texture = "res://flying objects/patyk.png",
		broken = "res://flying objects/patyk.png",
		type = POSITIVE
	},
	{
		texture = "res://flying objects/plotek.png",
		broken = "res://flying objects/deski.png",
		type = POSITIVE
	},
	{
		texture = "res://flying objects/kula.png",
		type = NEGATIVE
	},
	{
		texture = "res://flying objects/cegla.png",
		type = NEGATIVE
	},
	{
		texture = "res://flying objects/tv.png",
		type = NEGATIVE
	}
]

func _ready():
	set_process(true)
	var a = items[randi() % items.size()]
	type = a.type
	get_node("flying/Sprite").set_texture(load(a.texture))
	if type == POSITIVE:
		get_node("carried").set_texture(load(a.broken))
