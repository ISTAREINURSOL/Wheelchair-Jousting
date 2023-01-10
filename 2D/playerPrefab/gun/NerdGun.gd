extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rotato = rotation_degrees
var once = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	look_at(get_global_mouse_position())
	if rotation_degrees >= 360:
		rotation_degrees = 0
	elif rotation_degrees <= -1:
		rotation_degrees = 359
	#6print(rotation_degrees)
	if once:
		if Input.is_action_pressed("Shoot"):
			print("AH FUCK IM DYING")
	else:
		pass

