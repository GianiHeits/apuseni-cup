extends Node2D

var decelerate = false

func _ready():
	global_position = GameState.player_position

func _process(delta):
	if GameState.game_paused:
		return
	
	var move_speed = Vector2(GameState.move_speed_x, GameState.move_speed_y)
	position -= move_speed * delta
	
	if decelerate:
		GameState.move_speed_x = move_toward(GameState.move_speed_x, 0, 5000 * delta)
		GameState.move_speed_y = move_toward(GameState.move_speed_y, 0, 5000 * delta)

func _on_Area2D_area_entered(area):
	decelerate = true
