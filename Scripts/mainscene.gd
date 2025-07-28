extends Node2D

@export var spawnFreq = 300
@export var maxSpawnFreq = 150
@export var spawnSpeedUp = 0.98
@export var startingAsteroids = 4
var currAsteroids = 0
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
	spawnAsteroid()
	#for i in startingAsteroids:
	#	spawnAsteroid()
	gameOn = true

func spawnPlayer():
	var newPlayer = playerPrefab.instantiate()
	newPlayer.killed.connect(_on_player_killed)
	add_child(newPlayer)
	newPlayer.position = screen_size/2

func spawnAsteroid(newAsteroidPosition = null, newAsteroidSize = null):
	currAsteroids += 1
	if (newAsteroidPosition == null):
		match(randi_range(0,3)):
			0:
				newAsteroidPosition = Vector2(randf_range(0,screen_size.x), 0)
			1:
				newAsteroidPosition = Vector2(randf_range(0,screen_size.x), screen_size.y)
			2:
				newAsteroidPosition = Vector2(0, randf_range(0,screen_size.y))
			3:
				newAsteroidPosition = Vector2(0, randf_range(screen_size.x,screen_size.y))
	var newAstro = asteroidPrefab.instantiate()
	newAstro.asteroidKablooied.connect(_on_asteroid_kablooied)
	newAstro.asteroidNeedsChild.connect(_on_asteroid_needs_child)
	call_deferred("add_child",newAstro)
	if (newAsteroidSize != null):
		newAstro.asteroidSize = newAsteroidSize
	newAstro.position = newAsteroidPosition
	newAstro.checkSize()
	
func _process(delta):
	if gameOn == false or currAsteroids >= score:
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
	currAsteroids -= 1
	$asteroidHitSfx.play()
	$HUD.update_score(score)
	
func _on_asteroid_needs_child(asteroid) -> void:
	spawnAsteroid(asteroid.position, asteroid.asteroidSize - 0.5)
	spawnAsteroid(asteroid.position, asteroid.asteroidSize - 0.5)

func _on_player_killed() -> void:
	$musicPlayer.playing = false
	$deathSfx.play()
	gameOver.emit()
	gameOn = false

func _on_hud_start_game() -> void:
	$musicPlayer.playing = true
	currAsteroids = 0
	#clear out asteroids
	for child in get_children():
		if child.is_in_group("asteroids"):
			child.free()
	_startgame()
