extends Node2D

onready var progress_bar = $"%ProgressBar"
onready var speed_label = $"%SpeedLabel"
onready var end_screen = $"%EndScreen"

onready var main_theme = $MainTheme
onready var celebration = $Celebration
onready var spawner = $Spawner

var distance = 0
var max_player_speed = 0
var accelerate_player = false

var main_theme_time = 3
var main_theme_total_time = 2 * 60 + 32
var stone_type = "Stone"
var spawned_end_screen = false

func _ready():
	print(GameState.highscore_submitted, GameState.highscore)
	
	progress_bar.max_value = main_theme_total_time
	
	if GameState.seen_tutorial:
		_on_TutorialButton_pressed()

func _input(event):
	if event.is_action_pressed("ui_accept") and $"%TutorialScreen".visible:
		_on_TutorialButton_pressed()
	if event.is_action_pressed("ui_cancel"):
		_on_pause_button_pressed()

func _process(_delta):
	if GameState.game_paused:
		return
	
	var player_speed = GameState.move_speed_y / 1000.0 * 2
	max_player_speed = max(max_player_speed, player_speed)
	speed_label.text = "%.2f mps"%player_speed
	
	distance += GameState.move_speed_y / 1e4 
	main_theme_time = main_theme.get_playback_position()
	progress_bar.value = main_theme_time
	
	if main_theme_time >= main_theme_total_time - 2 and not spawned_end_screen:
		spawner.spawn_object_at_end("RaceEnd")
		spawned_end_screen = true
	
	if main_theme_time >= main_theme_total_time:
		celebration.play(1)
		_on_player_player_hit_obstacle()
	
	if accelerate_player and int(GameState.total_time * 10) % 10 == 0:
		GameState.move_speed_y += GameState.acceleartion

func _on_pause_button_pressed():
	if not GameState.game_started or GameState.game_over:
		return
	
	if not GameState.game_paused:
		main_theme.stop()
		GameState.game_paused = true
		$"%PauseScreen".visible = true
		for timer in $Timers.get_children():
			timer.paused = true
	else:
		_on_resume_pressed()

func _on_player_player_hit_obstacle():
	GameState.completion = (main_theme_time / main_theme_total_time) * 100
	GameState.max_player_speed = max_player_speed
	GameState.total_distance = distance
	
	GameState.game_paused = true
	GameState.game_over = true
	
	main_theme.stop()
	end_screen._on_game_over()

func _on_resume_pressed():
	main_theme.play(main_theme_time)
	GameState.game_paused = false
	$"%PauseScreen".visible = false
	for timer in $Timers.get_children():
		timer.paused = false

func _on_restart_pressed():
	GameState._on_reset_button_pressed()

func show_warning(text):
	$"%Warning".text = text
	$"%Warning".get_node("AnimationPlayer").play("Show")

func _on_level_1_timeout():
	if GameState.game_over:
		return
	accelerate_player = true
	show_warning("Steeper Slopes")

func _on_level_2_timeout():
	if GameState.game_over:
		return
	GameState.acceleartion += 5
	show_warning("Steeper Slopes")

func _on_level_3_timeout():
	if GameState.game_over:
		return
	show_warning("Stones")
	$DependentTimers/StoneSpawner.start()

func _on_level_4_timeout():
	if GameState.game_over:
		return
	show_warning("Bigger Stones")
	stone_type = "BiggerStone"

func _on_level_5_timeout():
	if GameState.game_over:
		return
	spawner.stop_spawing_people = true
	spawner.spawn_object_at_beggining("Yeti", true)
	show_warning("Yeti")

func _on_level_6_timeout():
	if GameState.game_over:
		return
	spawner.spawn_object_at_beggining("Avalanche", true)
	show_warning("Avalanche")

func _on_level_7_timeout():
	if GameState.game_over:
		return
	GameState.acceleartion += 5
	show_warning("Steeper Slopes")

func _on_ramp_spawner_timeout():
	if GameState.game_over:
		return
	spawner.spawn_object_at_end("Ramp", true)
	$Timers/RampSpawner.start()

func _on_stone_spawner_timeout():
	if GameState.game_over or stone_type == null:
		return
	spawner.spawn_object_at_end(stone_type, true)
	$DependentTimers/StoneSpawner.start()

func _on_TutorialButton_pressed():
	GameState.seen_tutorial = true
	$"%TutorialScreen".visible = false
	$"%Time".visible = true

func _on_Player_player_started_game():
	for timer in $Timers.get_children():
		timer.start()
	
	main_theme.play(main_theme_time)
	GameState.game_started = true
