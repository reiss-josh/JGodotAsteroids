extends Node2D

@export var spawnFreq = 400
@export var maxSpawnFreq = 60
@export var spawnSpeedUp = 0.85
@export var startingAsteroids = 4
var asteroidPrefab = load("res://Scenes/Asteroid.tscn")
var spawnTimer = 0
var screen_size
var score = 0

func _ready():
	screen_size = get_viewport_rect().size
	spawnTimer = spawnFreq
	score = 0
	for i in startingAsteroids:
		spawnAsteroid()

func spawnAsteroid():
	var rPos
	match(randi_range(0,3)):
		0:
			rPos = Vector2(randf_range(0,screen_size.x), 0)
		1:
			rPos = Vector2(randf_range(0,screen_size.x), screen_size.y)
		2:
			rPos = Vector2(0, randf_range(0,screen_size.y))
		3:
			rPos = Vector2(0, randf_range(screen_size.x,screen_size.y))
		
	var newAstro = asteroidPrefab.instantiate()
	newAstro.asteroidKablooied.connect(_on_asteroid_kablooied)
	add_child(newAstro)
	newAstro.position = rPos
	
func _process(delta):
	if(spawnTimer >= 0):
		spawnTimer -= delta*100
	else:
		spawnAsteroid()
		spawnTimer = spawnFreq
		if(spawnFreq > maxSpawnFreq):
			spawnFreq = spawnFreq * spawnSpeedUp
		elif(spawnFreq < maxSpawnFreq):
			spawnFreq = maxSpawnFreq


func _on_asteroid_kablooied() -> void:
	score = score+1
	$HUD.update_score(score)
