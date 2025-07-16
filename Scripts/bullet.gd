extends Area2D

@export var bulletSpeed = 800
@export var bulletOffset = 32
var screen_size

#ready
func _ready():
	screen_size = get_viewport_rect().size
	
func _process(delta):
	var facing_vector = Vector2(cos(rotation),sin(rotation))
	position += facing_vector * bulletSpeed * delta
	
	if(position.x < 0-bulletOffset or position.x > screen_size.x+bulletOffset
	or position.y < 0-bulletOffset or position.y > screen_size.y+bulletOffset):
		queue_free()
