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
	var xDir = (
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left") 
		)
	
	if xDir == 1:
		velocity.x = speed.x
		Dir = true
	elif xDir == -1:
		velocity.x = speed.x * -1
		Dir = false
	elif xDir == 0:
		if is_on_floor():
			velocity.x = velocity.x / 1.1
		else:
			velocity.x = velocity.x / 1.05
			
	if Input.is_action_just_pressed("Dash"):
		if Dir == true and not xDir == 1:
			velocity.x += 1200
		elif Dir == false and not xDir == -1:
			xDir = 0
			velocity.x -= 1200
		
	velocity.y += grav * delta 
	var _falling = velocity.y > 0 and not is_on_floor()
	var jumping = Input.is_action_just_pressed("jump") #and is_on_floor()
	var jumpCancel = Input.is_action_just_released("jump") and velocity.y < 0
	var _idle = is_on_floor() and is_zero_approx(velocity.x)
	var _onFloorWheel = is_on_floor() and not is_zero_approx(velocity.x)
	
	if not is_on_floor():
		coyoteTime()
	if is_on_floor():
		canJump = true
	
	if Input.is_action_pressed("move_down"):
		boolFastFall = true
		fastFall()
	elif not Input.is_action_pressed("move_down"):
		boolFastFall = false
		fastFall()

	if jumping:
		if canJump:
			velocity.y -= rocketJumpStr
	elif jumpCancel:
		velocity.y *= jumpDampen
		
	velocity = move_and_slide(velocity, UP_DIRECTION)
	if Input.is_action_just_pressed("reset"):
		position = startingPos
	
	
func coyoteTime():
	yield(get_tree().create_timer(.1), "timeout")
	canJump = false

func fastFall():
	grav = clamp(grav, 2000, 4000)
	if boolFastFall:
		grav = grav * 1.5
	else:
		grav = grav / 1.5
