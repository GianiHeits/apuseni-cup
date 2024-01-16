extends Node2D

const MAX_POINTS: int = 100
var past_locations = []
var is_stopped = false

export var is_npc = false

func _process(delta):
	if GameState.game_over or GameState.game_paused:
		return
	
	if is_npc:
		apply_npc_logic(delta)
	else:
		apply_player_logic(delta)

func stop():
	is_stopped = true

func apply_npc_logic(delta):
	var npc_speed = owner.bonus_speed
	
	for point_idx in len(past_locations):
		past_locations[point_idx] -= Vector2(0, npc_speed) * delta
	
	if len(past_locations) > MAX_POINTS and GameState.move_speed_y:
		past_locations.pop_at(0)
	past_locations.append(Vector2.ZERO)
	
	$TrailLeft.points = past_locations
	$TrailRight.points = past_locations

func apply_player_logic(delta):
	for point_idx in len(past_locations):
		past_locations[point_idx] -= Vector2(GameState.move_speed_x, GameState.move_speed_y) * delta
	
	if !is_stopped:
		if len(past_locations) > MAX_POINTS:
			past_locations.pop_at(0)
		past_locations.append(Vector2.ZERO)
	
	$TrailLeft.points = past_locations
	$TrailRight.points = past_locations
