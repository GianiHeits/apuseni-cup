extends Area2D

var margin_px = 32
var on_screen = true

export var has_bonus_speed = false
export var is_spectator = false

var bonus_speed_min = 50
var bonus_speed_max = 120
var bonus_speed = 0

var points = 100

signal exited_screen_on_up(main_group)
signal exited_screen_on_left(main_group)
signal exited_screen_on_right(main_group)

func _ready():
	var variations = $Variations.get_children()
	variations.shuffle()
	variations[0].visible = true
	
	if is_spectator:
		var random_delay = Utils.random_sample_from_range(0, 5, 1)[0] / 10.0
		yield(get_tree().create_timer(random_delay), "timeout")
		$TrailEffect.visible = false
		$AnimationPlayer.play("Cheer")
	
	if has_bonus_speed:
		bonus_speed = Utils.random_sample_from_range(bonus_speed_min, bonus_speed_max, 1)[0]

func _process(delta):
	if GameState.game_paused or is_spectator:
		return
	
	var move_speed = Vector2(GameState.move_speed_x, GameState.move_speed_y) - Vector2(0, bonus_speed)
	position -= move_speed * delta
	
	if global_position.y < -margin_px:
		_on_exited_viewport_vertically()
	
	if on_screen and global_position.x < -margin_px:
		emit_signal("exited_screen_on_left", get_groups())
		queue_free()

	if on_screen and global_position.x > GameState.viewport_size.x + margin_px:
		emit_signal("exited_screen_on_right", get_groups())
		queue_free()

func _on_exited_viewport_vertically():
	emit_signal("exited_screen_on_up", get_groups())
	queue_free()
