####################################
# TODO: CONVERT PHYSICS AND MAYBE  #
# THIS INTO A CLASS                #
# FOR POSSIBLE MULTIPLAYER         #
# I.E: HOW THEY DID IT IN THE DEMO #
# YOU SHAMELESSLY STOLE FROM       #  
####################################

extends KinematicBody2D

const UP_DIRECTION = Vector2.UP


export onready var grav = ProjectSettings.get("physics/2d/default_gravity")
export var speed = Vector2(300, 0) # How fast the player will move (pixels/sec).
export var jumpDampen = 0.35
export var momentumDampen = 0.1
export var type = "Player"


onready var boolet = preload("res://2D/playerPrefab/gun/boolet.tscn")
var velocity = Vector2.ZERO #defines the velocity
var rocketCharges = 2
var once = false
var bam = true
var DashCool = true
var SPEEDWOOOO = false
var startingPos
var canJump
var boolFastFall
var Dir
var bulletsPresent = 0

export var rocketJumpStr = 900
var screen_size # Size of the game window.


# Called when the node enters the scene tree for the first time.
func _ready():
	startingPos = position
	screen_size = get_viewport_rect().size
	canJump = false
	match type:
		"Player":
			print("CLIENT / P1 SPAWNED")
		"Void": #not assigned control
			print("CPU / P2 SPAWNED")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += grav * delta 
	match type:
		"Player":
			Player_Controlled()
		"Void": #not assigned control
			velocity = move_and_slide(velocity, UP_DIRECTION)
	

func Player_Controlled():
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


	if rocketCharges == 0 or rocketCharges < 2 and is_on_floor():
		if !once:
			$"Dash cooldown".start()
		once = true

	if Input.is_action_just_pressed("Dash"):
		if rocketCharges != 0:
			rocketCharges -= 1
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
		else:
			pass

	if jumping and canJump:
			if rocketCharges != 0:
				velocity.y -= rocketJumpStr
				rocketCharges -= 1
	elif jumpCancel:
		velocity.y *= jumpDampen


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
	if is_on_floor() and rocketCharges > 0:
		canJump = true
	
	fastFall()

	velocity = move_and_slide(velocity, UP_DIRECTION)

	if Input.is_action_just_pressed("reset"):
		position = startingPos
		
	var bullet = boolet.instance()
	if Input.is_action_pressed("Shoot") and bam:
		get_node("/root/Arena").add_child(bullet, true)
		bullet.assign("P1")
		bullet.global_position = position
		bullet.rotation_degrees = $"/root/Arena/Player/NerdGun".rotation_degrees
		$"FireRate".start()
		bulletsPresent += 1
		bam = false
		
	$"NerdGun".update()

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
	rocketCharges = 2
	DashCool = true
	once = false

func _on_FireRate_timeout():
	bam = true


func _on_Area2D_area_entered(area):
	match area.who:
		"P1":
			print("OUCH FUCK THAT HURT")
		_:
			print("i fucked up somehow")
	area.queue_free()
	$"/root/Arena/Player".bulletsPresent -= 1


func _on_VisibilityNotifier2D_screen_exited():
	if position.y < 0 and position.x > 0 and position.x < 720:
		pass
	else:
		position = startingPos
