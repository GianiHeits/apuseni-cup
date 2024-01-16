extends Area2D

var margin_px = 25

func _process(delta):
	if GameState.game_paused:
		return
	
	var move_speed = Vector2(GameState.move_speed_x, GameState.move_speed_y)
	position -= move_speed * delta
	
	if global_position.y < -margin_px:
		_on_exited_viewport_vertically()

func _on_exited_viewport_vertically():
	queue_free()
