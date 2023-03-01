extends RichTextLabel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var Charges = str($"../Player".rocketCharges)
	var Boosters = str($"../Player/Dash cooldown".is_stopped())
	var Speed = str($"../Player".speed.x)
	var Frames = str(Engine.get_frames_per_second())
	var PosX = str(round($"../Player".position.x))
	var PosY = str(round($"../Player".position.y))
	var Rotate = str(round($"../Player/NerdGun".rotation_degrees))
	var bulletsPresent = str($"../Player".bulletsPresent)
	var knockback1 = str($"../Player".knockback)
	var knockback2 = str($"../CPU".knockback)
	var knockback3 = str($"../CPU2".knockback)

	text = Frames + '\n' + PosX + ", " + PosY + '\n' + "Boosters: " + Boosters + '\n' + "Charges Left: " + Charges + '\n' + "Speed: " + Speed + '\n' + Rotate + '\n' + "Entities: " + bulletsPresent + '\n' + "P1: " + knockback1 + '\n' + "P2: " + knockback2 + '\n' + "P3: " + knockback3
