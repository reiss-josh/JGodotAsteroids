extends Area2D

@export var asteroidMinMoveSpeed = 50
@export var asteroidMaxMoveSpeed = 100
@export var asteroidRotateSpeed = 0
@export var asteroidOffset = 32
@export var asteroidStartingAngle = Vector2(0,0)
@export var asteroidMaxSize = 2
@export var asteroidMinSize = 0.5
var asteroidSize = asteroidMaxSize
var asteroidMoveSpeed
var asteroidRotationSpeed
var asteroidHeadingVector
var screen_size
signal asteroidKablooied
signal asteroidNeedsChild

func _ready():
	#this is bad but it works -- randomly sets asteroid's start angle
	while(asteroidStartingAngle == Vector2(0,0)):
		asteroidStartingAngle = Vector2(randf_range(-1,1), randf_range(-1,1)).normalized()
	asteroidHeadingVector = asteroidStartingAngle
	asteroidMoveSpeed = randi_range(asteroidMinMoveSpeed,asteroidMaxMoveSpeed)
	#randomly flip direction at spawn
	#if(randi_range(0,1) == 0):
	#	asteroidMoveSpeed = asteroidMoveSpeed * -1
	#rotation = asteroidStartingAngle
	screen_size = get_viewport_rect().size
	add_to_group("asteroids")

func _process(delta):
	position += asteroidHeadingVector * asteroidMoveSpeed * delta
	
	if(position.x < 0-asteroidOffset):
		position.x = screen_size.x+(asteroidOffset/2.0)
	elif(position.x > screen_size.x+asteroidOffset):
		position.x = 0-(asteroidOffset/2.0)
	elif(position.y < 0-asteroidOffset):
		position.y = screen_size.y+(asteroidOffset/2.0)
	elif(position.y > screen_size.y+asteroidOffset):
		position.y = 0-(asteroidOffset/2.0)

	$Sprite2D.rotation += (asteroidMoveSpeed*0.05*delta)

func checkSize():
	if (Vector2(asteroidSize,asteroidSize) != scale):
		scale = Vector2(asteroidSize,asteroidSize)

func isPositive(myValue):
	if myValue > 0:
		return true
	else:
		return false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("bullets"):
		asteroidKablooied.emit()
		if(asteroidSize > asteroidMinSize):
			asteroidNeedsChild.emit(self)
		#print("bullet kill me!!")
		queue_free()
	if area.is_in_group("asteroids"):
		#check if heading towards impacted asteroid
		var fromMeToThem = (area.position-position).normalized()
		if (isPositive(asteroidHeadingVector.x)) == isPositive(fromMeToThem.x) or (isPositive(asteroidHeadingVector.y) == isPositive(fromMeToThem.y)):
			#get and normalized vector pointing from asteroid to self
			asteroidHeadingVector = (position - area.position).normalized()
			#print(asteroidHeadingVector)
