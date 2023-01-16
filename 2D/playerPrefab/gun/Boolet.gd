extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var who = "null"
var hidden = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func assign(owner):
	who = owner

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	move_local_x(500 * _delta)
	if hidden:
		queue_free()
		$"/root/Arena/Player".bulletsPresent -= 1

func _on_VisibilityNotifier2D_screen_exited():
	hidden = true
