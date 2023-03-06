####################################
# TODO: CONVERT PHYSICS AND MAYBE  #
# THIS INTO A CLASS                #
# FOR POSSIBLE MULTIPLAYER         #
# I.E: HOW THEY DID IT IN THE DEMO #
# YOU SHAMELESSLY STOLE FROM       #  
####################################

# thanks me

extends CharacterBody2D

const UP_DIRECTION = Vector2.UP


@onready var grav = ProjectSettings.get("physics/2d/default_gravity")
@export var speed = Vector2(300, 0) # How fast the player will move (pixels/sec).
@export var jumpDampen = 0.35
@export var momentumDampen = 0.1
@export var knockback = 500
@export var type = "Player"


@onready var boolet = preload("res://2D/playerPrefab/gun/boolet.tscn")
var rocketCharges = 2
var once = false
var bam = true
var DashCool = true
var SPEEDWOOOO = false
var bulletsPresent = 0
var startingPos
var canJump
var boolFastFall
var Dir
var bruh = "null"
var who = "test"

@export var rocketJumpStr = 900
var screen_size # Size of the game window.


# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2.ZERO #defines the velocity
	startingPos = position
	screen_size = get_viewport_rect().size
	#OS.center_window()
	canJump = false
	match type:
		"Player":
			print("CLIENT / P1 SPAWNED")
		"Void": #not assigned control
			print("VOID / P2 SPAWNED")
		"CPU":
			print("DIDNT CODE THAT YET DUMBASS")
			print("VOID / P2 SPAWNED")
			type = "Void"
		_:
			print("INVALID STRING DUMBASS")
			print("FALLING BACK TO VOID BEHAVIOUR")
			print("VOID / P2 SPAWNED")
			type = "Void"
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.y += grav * delta 
	match type:
		"Player":
			Player_Controlled()
		"Void": #not assigned control
			No_Control()

func No_Control():
	set_velocity(velocity)
	set_up_direction(UP_DIRECTION)
	move_and_slide()
	velocity = velocity
	if is_on_floor():
		velocity.x = velocity.x / 1.1
	else:
		velocity.x = velocity.x / 1.05
	
	if Input.is_action_just_pressed("reset"):
		position = startingPos
		velocity = Vector2.ZERO
		knockback = 500

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
		#await get_tree().create_timer(.75).timeout
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

	set_velocity(velocity)
	set_up_direction(UP_DIRECTION)
	move_and_slide()
	velocity = velocity

	if Input.is_action_just_pressed("reset"):
		position = startingPos
		velocity = Vector2.ZERO
		
	var bullet = boolet.instantiate()
	if Input.is_action_pressed("Shoot") and bam:
		get_node("/root/Arena").add_child(bullet, true)
		bullet.assign(str($"."))
		print('\n' + "PROJ SHOT FROM: " + str($".") + '\n')
		bullet.global_position = position
		bullet.rotation_degrees = $"/root/Arena/Player/NerdGun".rotation_degrees
		$"FireRate".start()
		bulletsPresent += 1
		bam = false
	$"NerdGun".update()

func coyoteTime():
	await get_tree().create_timer(.1).timeout
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
	print("ACTOR HIT: " + str($"."))
	print("HIT BY: " + area.who + '\n')
	if area.who.begins_with("Player"):
		print("OUCH FUCK THAT HURT")
		knockback += 100
		print(area.rotation_degrees)
		velocity.x -= knockback * sin(area.get_rotation() - PI/2) # originally used rad_to_deg so i could use degrees but
		velocity.y += knockback * sin(area.get_rotation())        # that used too many brackets and made this look like shit
		print(area.get_rotation())
		print("Vert Vel: " + str(knockback * sin(area.get_rotation()))) # same story as above
		print("Hor Vel: " + str(knockback * sin(area.get_rotation() - PI/2)))
		area.queue_free()
		bulletsPresent -= 1
	else:
		print("FUCK")


func _on_VisibilityNotifier2D_screen_exited():
	if position.y < 0 and position.x > 0 and position.x < 720:
		pass
	else:
		print('\n' + "HAHAHA FUCK YOU")
		print(position)
		position = startingPos
