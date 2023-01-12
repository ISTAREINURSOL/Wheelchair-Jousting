####################################
# TODO: CONVERT PHYSICS AND MAYBE  #
# THIS INTO A CLASS                #
# FOR POSSIBLE MULTIPLAYER         #
# I.E: HOW THEY DID IT IN THE DEMO #
# YOU SHAMELESSLY STOLE FROM       #  
####################################

extends KinematicBody2D

const UP_DIRECTION = Vector2.UP

export var speed = Vector2(300, 0) # How fast the player will move (pixels/sec).
export onready var grav = ProjectSettings.get("physics/2d/default_gravity")
export var jumpDampen = 0.35
export var momentumDampen = 0.1
var velocity = Vector2.ZERO #defines the velocity
var startingPos
var canJump
var boolFastFall
var once = false
var Dir
var rocketCharges = 1
var DashCool = true
var SPEEDWOOOO = false

export var rocketJumpStr = 900
var screen_size # Size of the game window.


# Called when the node enters the scene tree for the first time.
func _ready():
	startingPos = position
	screen_size = get_viewport_rect().size
	canJump = false
	print("CLIENT / P1 SPAWNED")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	velocity.y += grav * delta 
	var _falling = velocity.y > 0 and not is_on_floor()
	var jumping = Input.is_action_just_pressed("jump") #and is_on_floor()
	var jumpCancel = Input.is_action_just_released("jump") and velocity.y < 0
	var _idle = is_on_floor() and is_zero_approx(velocity.x)
	var _onFloorWheel = is_on_floor() and not is_zero_approx(velocity.x)
	
	var xDir = (
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left") 
		)
	if xDir == 0:
		if is_on_floor():
			velocity.x = velocity.x / 1.1
		else:
			velocity.x = velocity.x / 1.05
	elif xDir == 1:
		velocity.x = speed.x
		Dir = true
	elif xDir == -1:
		velocity.x = speed.x * -1
		Dir = false

	if Input.is_action_just_pressed("Dash"):
		if xDir != 0:
			if DashCool:
				speed.x = 1200
				SPEEDWOOOO = true
		else:
			if DashCool:
				if Dir == true and not xDir == 1:
					velocity.x += 1200
				elif Dir == false and not xDir == -1:
					velocity.x -= 1200
		if rocketCharges == 0:
			DashCool = false
			$"Dash cooldown".start()
		else:
			rocketCharges -= 1

	if jumping:
		if DashCool:
			if canJump:
				velocity.y -= rocketJumpStr
				if rocketCharges == 0:
					DashCool = false
					$"Dash cooldown".start()
				else:
					rocketCharges -= 1
	elif jumpCancel:
		velocity.y *= jumpDampen
		
	if is_on_floor():
		rocketCharges = 1

	if 	SPEEDWOOOO:
		#yield(get_tree().create_timer(.75), "timeout")
		if is_on_floor():
			speed.x = speed.x / 1.1 
		else:
			speed.x = speed.x / 1.05
		speed.x = clamp(speed.x, 300, 1200)
		if speed.x == 300:
			SPEEDWOOOO = false

	if not is_on_floor() and rocketCharges <= 0:
		coyoteTime()
	if is_on_floor() or rocketCharges > 0:
		canJump = true
	
	if Input.is_action_pressed("move_down"):
		fastFall()
	elif not Input.is_action_pressed("move_down"):
		fastFall()

	velocity = move_and_slide(velocity, UP_DIRECTION)
	if Input.is_action_just_pressed("reset"):
		position = startingPos


func coyoteTime():
	yield(get_tree().create_timer(.1), "timeout")
	canJump = false

func fastFall():
	grav = clamp(grav, 2000, 3500)
	if Input.is_action_pressed("move_down"):
		grav = grav * 1.5
	else:
		grav = grav / 1.5


func _on_Dash_cooldown_timeout():
	DashCool = true
	rocketCharges = 1
