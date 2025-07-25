extends HSlider

@export var targetBus = "Master"

func _ready():
	$TestTonePlayer.bus = targetBus

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(targetBus),value)
	#print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(targetBus)))

func _on_drag_ended(value_changed: bool) -> void:
	$TestTonePlayer.play()
