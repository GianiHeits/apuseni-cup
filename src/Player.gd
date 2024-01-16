extends Area2D

const SnowTrailScene = preload("res://src/effects/TrailEffect.tscn")
const BonusPointsScene = preload("res://src/effects/BonusPoints.gd")

var should_accelearte = false
var should_decelerate = false

var strife_left = false
var strife_right = false
var is_jumping = false
var prev_trail = null

onready var sprite_stop = $SpriteStop
onready var sprite_move = $SpriteMove
onready var oof_sound = $OofSoundEffect
onready var animation_player = $AnimationPlayer

signal player_started_game
signal player_hit_obstacle


func _ready():
	position = GameState.player_position

func _input(event):
	if not GameState.seen_tutorial or GameState.game_over:
		return
	
	if event.is_action_pressed("ui_down"):
		should_accelearte = true
	elif event.is_action_released("ui_down"):
		should_accelearte = false
	elif event.is_action_pressed("ui_up"):
		should_decelerate = true
	elif event.is_action_released("ui_up"):
		should_decelerate = false
	
	if event.is_action_pressed("ui_left"):
		strife_left = true
	elif event.is_action_released("ui_left"):
		strife_left = false
	
	if event.is_action_pressed("ui_right"):
		strife_right = true
	elif event.is_action_released("ui_right"):
		strife_right = false
	
	if event.is_action_pressed("ui_accept"):
		if not is_jumping and GameState.move_speed_y > 100:
			jump()
	
	if GameState.game_paused and should_accelearte:
		emit_signal("player_started_game")
		GameState.game_paused = false

func _process(_delta):
	if GameState.game_paused:
		return
	
	if strife_right == strife_left:
		GameState.move_speed_x = 0
	else:
		var srtife_speed = GameState.strife_perc * GameState.move_speed_y
		GameState.move_speed_x = -srtife_speed if strife_left else srtife_speed
	 
	if is_jumping:
		stop_trail()
		return
	
	if GameState.move_speed_y <= GameState.min_speed_y:
		sprite_move.visible = false
	else:
		sprite_move.visible = true
		spawn_trail()
	
	if should_accelearte and GameState.move_speed_y < GameState.max_speed_y:
		GameState.move_speed_y += GameState.acceleartion
	if should_decelerate and GameState.move_speed_y > GameState.min_speed_y:
		GameState.move_speed_y -= GameState.deceleration

func jump():
	is_jumping = true
	animation_player.play("Jumping")

func _on_area_entered(area):
	if "Ramp" in area.get_groups():
		_on_hit_ramp(200)
	elif "Obstacle" in area.get_groups():
		if "Jumpable" in area.get_groups() and is_jumping:
			get_points(area.points)
			return
		if not GameState.game_over:
			GameState.move_speed_x = 0
			oof_sound.play(0.2)
			emit_signal("player_hit_obstacle")

func _on_hit_ramp(points):
	get_points(points)
	jump()

func _on_finished_jumping():
	is_jumping = false

func spawn_trail():
	if prev_trail != null:
		return
	
	prev_trail = SnowTrailScene.instance()
	add_child(prev_trail)

func stop_trail():
	if prev_trail == null:
		return
		
	prev_trail.stop()
	prev_trail = null

func get_points(points):
	GameState.bonus_points += points
	var pos_x = Utils.random_sample_from_range(global_position.x + 16, global_position.x + 32, 1)[0]
	var pos_y = Utils.random_sample_from_range(global_position.y - 32, global_position.y, 1)[0]
	Utils.instance_scene_on_main(BonusPointsScene, Vector2(pos_x, pos_y), {"points": points})
	$CoinEffect.play(0.3)
