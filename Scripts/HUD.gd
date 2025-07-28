extends CanvasLayer

signal start_game

func update_score(score):
	#print(score)
	$ScoreLabel.text = str(score)

func _on_game_over() -> void:
	var score = $ScoreLabel.text
	$ScoreLabel.text = ""
	$Message.text = "sorry ... you have losing the game :(\nno more game for you :(\nyour score was:\n"+str(score)
	$MainMenu.visible = true
	$ScoreLabel.visible = false

func _on_start_button_button_up() -> void:
	$ScoreLabel.text = "0"
	$ScoreLabel.visible = true
	$MainMenu.visible = false
	$Message.text = ""
	start_game.emit()


func _on_quit_button_button_up() -> void:
	get_tree().quit()
