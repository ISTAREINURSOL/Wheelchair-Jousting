extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gOOO = false
var hidden = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#hide()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	move_local_x(500 * _delta)
	if hidden:
		$"/root/Arena/Player".bulletsPresent -= 1
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	hidden = true
