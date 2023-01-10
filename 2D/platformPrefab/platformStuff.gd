extends CollisionShape2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	if Input.get_action_strength("move_down") > 0:
		one_way_collision_margin = 0.0
	else:
		one_way_collision_margin = 1.0
	
