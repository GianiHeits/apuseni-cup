extends Panel

var placeholder_text = "- Your Best -"
var ldboard_name = "main"
var scores: Array
var PlaceContainerScene = preload("res://src/ui/PlaceContainer.tscn")


func update_scores():
	yield(SilentWolf.Scores.get_high_scores(5, ldboard_name), "sw_scores_received")
	scores = SilentWolf.Scores.scores
	
	var player_highscore = GameState.highscore
	var sw_player_position = SilentWolf.Scores.get_score_position(player_highscore, ldboard_name)
	var player_position = sw_player_position.position + 1
	
	if player_position <= len(scores):
		scores.insert(player_position - 1, {"score": player_highscore, "player_name": placeholder_text})
	else:
		scores.append({"score": player_highscore, "player_name": placeholder_text})
	
	for place in len(scores):
		var place_container = PlaceContainerScene.instance()
		$"%LaderboardContainer".add_child(place_container)
		$"%LaderboardContainer".move_child(place_container, place + 2)
		
		var player_name = scores[place]["player_name"]
		
		place_container.label = "%s. %s"%[place + 1, player_name]
		place_container.score = "%s"%[scores[place]["score"]]
		
		if player_name == placeholder_text:
			place_container.label = "%s. %s"%[player_position, player_name]
	
	if GameState.highscore_submitted:
		$"%SubmitContainer".visible = false
		$"%AlreadySubmitted".visible = true

func _on_SubmitButton_pressed():
	var metadata = {
		"total_distance": GameState.total_distance,
		"total_time": GameState.total_time,
		"completion": GameState.completion,
		"max_player_speed": GameState.max_player_speed,
		"bonus_points": GameState.bonus_points,
		"attempts": GameState.attempts
		}
	SilentWolf.Scores.persist_score($"%PlayerName".text, GameState.highscore, ldboard_name, metadata)
	GameState.highscore_submitted = true
	GameState._on_reset_button_pressed()

func _on_PlayerName_text_changed(new_text):
	var player_name = $"%PlayerName".text
	
	if player_name != "" and BadWordsFilter.is_word_ok(player_name) and not GameState.highscore_submitted:
		$"%SubmitButton".disabled = false
	else:
		$"%SubmitButton".disabled = true

func _on_Button_pressed():
	GameState._on_reset_button_pressed()
