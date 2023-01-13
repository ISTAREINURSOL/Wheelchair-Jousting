extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var boolet = preload("res://2D/playerPrefab/gun/boolet.tscn")
var index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func summonBoolet():
	var b = boolet.instance()
	add_child(b, true)
	
	pass
