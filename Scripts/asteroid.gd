extends Area2D

@export var asteroidMinMoveSpeed = 50
@export var asteroidMaxMoveSpeed = 100
@export var asteroidRotateSpeed = 0
@export var asteroidOffset = 32
var asteroidMoveSpeed
var asteroidRotationSpeed
var asteroidStartingAngle
var asteroidStartingVector
var screen_size
signal asteroidKablooied

func _ready():
	asteroidStartingAngle = randf_range(0,360)
	asteroidStartingVector = Vector2(cos(asteroidStartingAngle),sin(asteroidStartingAngle))
	asteroidMoveSpeed = randi_range(asteroidMinMoveSpeed,asteroidMaxMoveSpeed)
	if(randi_range(0,1) == 0):
		asteroidMoveSpeed = asteroidMoveSpeed * -1
	rotation = asteroidStartingAngle
	screen_size = get_viewport_rect().size
	add_to_group("asteroids")

func _process(delta):
	var beep = asteroidStartingVector * asteroidMoveSpeed * delta
	position += asteroidStartingVector * asteroidMoveSpeed * delta
	
	if(position.x < 0-asteroidOffset):
		position.x = screen_size.x+(asteroidOffset/2)
	elif(position.x > screen_size.x+asteroidOffset):
		position.x = 0-(asteroidOffset/2)
	elif(position.y < 0-asteroidOffset):
		position.y = screen_size.y+(asteroidOffset/2)
	elif(position.y > screen_size.y+asteroidOffset):
		position.y = 0-(asteroidOffset/2)

	$Sprite2D.rotation += (asteroidMoveSpeed*0.05*delta)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		asteroidKablooied.emit()
		#print("bullet kill me!!")
		queue_free()
