extends Area2D

@export var moveSpeedMax = 200
@export var moveAccel = 3
@export var moveDamping = 0.993
@export var rotSpeedMax = 7
@export var rotAccel = 3
@export var rotDamping = 0.9
@export var shootSpeed = 30
@export var bulletSpawnOffset = 32
var playerOffset = 8
var currVelocity
var shootBuffered
var shootTimer
var currMoveSpeed = moveAccel
var currRotSpeed = -rotAccel
var screen_size
var bulletPrefab = load("res://Scenes/Bullet.tscn")
var bulletInstance
signal killed

#ready
func _ready():
	screen_size = get_viewport_rect().size
	shootBuffered = 0
	shootTimer = 0
	currVelocity = Vector2.ZERO

#process
func _process(delta):
	var move_input = 0 #The player's move input
	var rot_input = 0 #The player's rotation input
	
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

	#play sounds for movement inputs
	if(not $moveThrusterSfx.playing and (Input.is_action_just_pressed("move_forward") or Input.is_action_just_pressed("move_backward"))):
		$moveThrusterSfx.pitch_scale = randf_range(0.75, 1.5)
		$moveThrusterSfx.play()
	if(not $rotThrusterSfx.playing and (Input.is_action_just_pressed("rotate_left") or Input.is_action_just_pressed("rotate_right"))):
		$rotThrusterSfx.pitch_scale = randf_range(0.75, 1.5)
		$rotThrusterSfx.play()
		
	#play animation if moving
	if move_input != 0:
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
#rotation update
	#check rotation inputs and calculate rotation speed
	if (rot_input != 0):
		currRotSpeed += rot_input * rotAccel * 0.1
	else:
		currRotSpeed = (currRotSpeed * rotDamping)
	#cap rotation speed
	currRotSpeed = clamp(currRotSpeed, -rotSpeedMax, rotSpeedMax)
	#do rotation update
	rotation += currRotSpeed * delta
	

#movement update
	#get rotation angle as a vector
	var facing_vector = Vector2(cos(rotation),sin(rotation))
	#check movement inputs and calculate velocity
	if (move_input != 0):
		currVelocity += move_input * facing_vector * moveAccel
	else:
		currVelocity = (currVelocity * moveDamping)
	#cap movement velocity by magnitude
	currVelocity = currVelocity.limit_length(moveSpeedMax)
	#print(currVelocity)
	#actually move
	position += currVelocity * delta
	
	if(position.x < 0-playerOffset):
		position.x = screen_size.x+(playerOffset/2.0)
	elif(position.x > screen_size.x+playerOffset):
		position.x = 0-(playerOffset/2.0)
	elif(position.y < 0-playerOffset):
		position.y = screen_size.y+(playerOffset/2.0)
	elif(position.y > screen_size.y+playerOffset):
		position.y = 0-(playerOffset/2.0)
	#position = position.clamp(Vector2.ZERO, screen_size)

#shooting
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
		
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("asteroids"):
		print("dead time")
		killed.emit()
		queue_free()
