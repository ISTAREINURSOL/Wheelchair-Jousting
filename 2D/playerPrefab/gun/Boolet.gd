extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var who = "null"
var testhidden = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func assign(owner):
	who = owner

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	move_local_x(500 * _delta)
	if testhidden:
		queue_free()
		$"/root/Arena/Player".bulletsPresent -= 1
	if rotation_degrees >= 360:
		rotation_degrees = 0
	elif rotation_degrees <= -1:
		rotation_degrees = 359

func _on_VisibilityNotifier2D_screen_exited():
	testhidden = true
	pass
