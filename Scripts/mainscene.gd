extends Node2D

@export var spawnFreq = 200
@export var maxSpawnFreq = 60
@export var spawnSpeedUp = 0.95
@export var startingAsteroids = 4
var asteroidPrefab = load("res://Scenes/Asteroid.tscn")
var playerPrefab = load("res://Scenes/Player.tscn")
var spawnTimer = 0
var screen_size
var score = 0
var gameOn = false
signal gameOver

func _ready():
	screen_size = get_viewport_rect().size
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"),-5.0)
	#_startgame()

func _startgame():
	spawnTimer = 0
	score = 0
	spawnPlayer()
	#for i in startingAsteroids:
	#	spawnAsteroid()
	gameOn = true

func spawnPlayer():
	var newPlayer = playerPrefab.instantiate()
	newPlayer.killed.connect(_on_player_killed)
	add_child(newPlayer)
	newPlayer.position = screen_size/2
	print("hi")

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
	if gameOn == false:
		return
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

func _on_player_killed() -> void:
	$musicPlayer.playing = false
	$deathSfx.play()
	gameOver.emit()
	gameOn = false

func _on_hud_start_game() -> void:
	$musicPlayer.playing = true
	#clear out asteroids
	for child in get_children():
		if child.is_in_group("asteroids"):
			child.free()
	_startgame()
