extends Area2D

@export var moveSpeedMax = 175
@export var moveAccel = 150
@export var moveDamping = 0.95
@export var rotSpeedMax = 5
@export var rotAccel = 10
@export var rotDamping = 0.9
@export var shootSpeed = 60
@export var bulletSpawnOffset = 32
var shootBuffered
var shootTimer
var currMoveSpeed = moveAccel
var currRotSpeed = -rotAccel
var screen_size
var bulletPrefab = load("res://Scenes/Bullet.tscn")
var bulletInstance

#ready
func _ready():
	screen_size = get_viewport_rect().size
	shootBuffered = 0
	shootTimer = 0

#process
func _process(delta):
	var move_input = 0 #The player's move input
	var rot_input = 0 #The player's rotation input
	#var move_direction_changed = false
	#var rot_direction_changed = false
	if Input.is_action_pressed("rotate_right"):
		rot_input += 1
	if Input.is_action_pressed("rotate_left"):
		rot_input -= 1
	if Input.is_action_pressed("move_forward"):
		move_input += 1
	if Input.is_action_pressed("move_backward"):
		move_input -= 1
	if Input.is_action_just_pressed("shoot_shoot"):
		shootBuffered = 1

	if(not $moveThrusterSfx.playing and (Input.is_action_just_pressed("move_forward") or Input.is_action_just_pressed("move_backward"))):
		$moveThrusterSfx.pitch_scale = randf_range(0.75, 1.5)
		$moveThrusterSfx.play()
	if(not $rotThrusterSfx.playing and (Input.is_action_just_pressed("rotate_left") or Input.is_action_just_pressed("rotate_right"))):
		$rotThrusterSfx.pitch_scale = randf_range(0.75, 1.5)
		$rotThrusterSfx.play()
		
	#accelerate
	if (move_input != 0):
		currMoveSpeed += move_input * moveAccel * delta
	else:
		currMoveSpeed = (currMoveSpeed * moveDamping)
	if (rot_input != 0):
		currRotSpeed += rot_input * rotAccel * delta
	else:
		currRotSpeed = (currRotSpeed * rotDamping)
		
	#speedcap
	currMoveSpeed = clamp(currMoveSpeed, -moveSpeedMax, moveSpeedMax)
	currRotSpeed = clamp(currRotSpeed, -rotSpeedMax, rotSpeedMax)

	#do the moving
	var facing_vector = Vector2(cos(rotation),sin(rotation))
	rotation += currRotSpeed * delta
	position += facing_vector * currMoveSpeed * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if(shootTimer > 0):
		shootTimer -= delta*100
	elif(shootBuffered == 1):
		shootTimer = shootSpeed
		bulletInstance = bulletPrefab.instantiate()
		get_parent().add_child(bulletInstance)
		bulletInstance.rotation = rotation
		bulletInstance.position = position + (bulletSpawnOffset * facing_vector)
		shootBuffered = 0
		$shootBulletSfx.pitch_scale = randf_range(0.75, 1.5)
		$shootBulletSfx.play()
	else:
		shootTimer = 0
		#
	
	#velocity = velocity.normalized() * moveSpeed
	
	#play animation if moving
	if move_input != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
