extends HSlider

@export var targetBus = "Master"

func _ready():
	$TestTonePlayer.bus = targetBus

func _on_value_changed(newvalue: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(targetBus),newvalue)
	#print(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(targetBus)))

func _on_drag_ended(_value_changed: bool) -> void:
	$TestTonePlayer.play()
