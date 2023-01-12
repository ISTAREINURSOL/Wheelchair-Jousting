extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func fire():
	look_at($"NerdGun".rotato)
	if rotation_degrees >= 360:
		rotation_degrees = 0
	elif rotation_degrees <= -1:
		rotation_degrees = 359
	print("AH FUCK IM DYING")
