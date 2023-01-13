extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gOOO = false


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#rotation_degrees = $"/root/Node2D/Player/NerdGun".rotato
	if rotation_degrees >= 360:
		rotation_degrees = 0
	elif rotation_degrees <= -1:
		rotation_degrees = 359
	if gOOO:
		move_local_x(500*delta)
		pass

func fire():
	show()
	position.x = $"/root/Arena/Player".position.x 
	position.y = $"/root/Arena/Player".position.y
	rotation_degrees = $"/root/Arena/Player/NerdGun".rotation_degrees
	gOOO = true
