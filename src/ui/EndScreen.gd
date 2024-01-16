extends Panel

export(NodePath) onready var leaderboard_path = get_node(leaderboard_path)


func _input(event):
	if event.is_action_pressed("ui_accept") and GameState.game_over:
		GameState._on_reset_button_pressed()

func _on_game_over():
	visible = true
	
	var score = int(Constants.max_score * GameState.completion * GameState.total_distance / 10000) + GameState.bonus_points
	
	if GameState.highscore < score:
		GameState.highscore = score
		GameState.highscore_submitted = false
		$"%HighScoreLabel".visible = true
	else:
		$"%HighScoreLabel".visible = false
	
	$"%ScoreLabel".text = str(score)
	
	$"%DistanceLabel".text = "%0.2f"%GameState.total_distance
	$"%MaxSpeedLabel".text = "%0.2f"%GameState.max_player_speed
	$"%AttemptsLabel".text = "%s"%GameState.attempts
	
	leaderboard_path.update_scores()

func _on_leaderboard_pressed():
	leaderboard_path.visible = true
	self.visible = false

func _on_Retry_pressed():
	GameState._on_reset_button_pressed()
