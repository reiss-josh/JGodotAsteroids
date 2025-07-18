extends CanvasLayer

signal start_game

func update_score(score):
	print(score)
	$ScoreLabel.text = str(score)


func _on_player_killed() -> void:
	var score = $ScoreLabel.text
	$ScoreLabel.text = ""
	$Message.text = "sorry ... you have losing the game :(\nno more game for you :(\nyour score was:\n"+str(score)
