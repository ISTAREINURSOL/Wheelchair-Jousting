extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var Charges = str($"/root/Node2D/Player".rocketCharges + 1)
	var Boosters = str($"/root/Node2D/Player/Dash cooldown".is_stopped())
	var Speed = str($"/root/Node2D/Player".speed.x)

	text = str(Engine.get_frames_per_second()) + '\n' + "Boosters: " + Boosters + '\n' + "Charges Left: " + Charges + '\n' + "Speed: " + Speed
