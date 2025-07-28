extends Sprite2D

var screen_size
var scrollSpeed = 20
var subX = 0
var selfSize = 1280

func _ready():
	subX = position.x
	screen_size = get_viewport_rect().size

func _process(delta):
	if(abs(position.x - subX) > 1.0):
		subX = position.x
	subX += scrollSpeed * delta
	position.x = snapped(subX,1)
	if(position.x >= selfSize):
		position.x = -screen_size.x-screen_size.x/2
