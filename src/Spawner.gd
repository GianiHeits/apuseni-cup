extends Node2D

const PersonScene = preload("res://src/spawnables/Person.tscn")
const TreeScene = preload("res://src/spawnables/Tree.tscn")
const RampScene = preload("res://src/spawnables/Ramp.tscn")
const StoneScene = preload("res://src/spawnables/Stone.tscn")
const BiggerStoneScene = preload("res://src/spawnables/BiggerStone.tscn")
const YetiScene = preload("res://src/spawnables/Yeti.tscn")
const AvalancheScene = preload("res://src/spawnables/Avalanche.tscn")

const RaceEndScene = preload("res://src/scene/RaceEndSprites.tscn")

var max_trees_per_row = 2
var object_spawn_x_variation = 0

var nb_of_trees = 4
var nb_of_people = 4
var stop_spawing_people = false

func _ready():
	# TODO consider recording inputs and letting players compete with after-image
	#seed(360)
	spawn_objects(nb_of_trees, "Tree", 3)
	spawn_objects(nb_of_people, "Person", 3)
	
	object_spawn_x_variation = GameState.x_shift / 2

func _on_object_exited_screen_on_up(object_type):
	var row_idx = Constants.max_rows_per_screen + 1
	var column_idx = Utils.random_sample_from_range(0, Constants.max_cols_per_screen, 1)[0]
	
	var tree_position = Vector2(column_idx * GameState.x_shift, row_idx * GameState.y_shift)
	var x_variation_amount = Utils.random_sample_from_range(-object_spawn_x_variation, object_spawn_x_variation, 1)[0]
	tree_position += Vector2(x_variation_amount, 0)
	_spawn_object_at(tree_position, object_type)

func _on_object_exited_screen_on_sides(object_type, direction):
	var row_idx = Utils.random_sample_from_range(0, Constants.max_rows_per_screen, 1)[0]
	var column_idx = 0 if direction == "right" else Constants.max_cols_per_screen - 1
	
	var tree_position = Vector2(column_idx * GameState.x_shift, row_idx * GameState.y_shift)
	_spawn_object_at(tree_position, object_type)

func _spawn_object_at(tree_position, object_type):
	var object = null
	if "Tree" in object_type:
		object = TreeScene.instance()
	elif "Person" in object_type:
		if stop_spawing_people:
			return
		object = PersonScene.instance()
	
	object.connect("exited_screen_on_up", self, "_on_object_exited_screen_on_up")
	object.connect("exited_screen_on_right", self, "_on_object_exited_screen_on_sides", ["right"])
	object.connect("exited_screen_on_left", self, "_on_object_exited_screen_on_sides", ["left"])
	add_child(object)
	object.global_position = tree_position

func spawn_objects(nb_of_objects, object_type, min_row):
	var trees_per_row = int(nb_of_objects / Constants.max_rows_per_screen)
	for row_idx in range(min_row, Constants.max_rows_per_screen):
		var trees_columns = Utils.random_sample_from_range(0, Constants.max_cols_per_screen, trees_per_row)
		
		for column_idx in trees_columns:
			var tree_position = Vector2(column_idx * GameState.x_shift, row_idx * GameState.y_shift)
			_spawn_object_at(tree_position, object_type)
	
	var trees_left = nb_of_objects % Constants.max_rows_per_screen
	var random_rows = Utils.random_sample_from_range(min_row, Constants.max_rows_per_screen, trees_left)
	for row_idx in random_rows:
		var trees_columns = Utils.random_sample_from_range(0, Constants.max_cols_per_screen, 1)
		
		for column_idx in trees_columns:
			var tree_position = Vector2(column_idx * GameState.x_shift, row_idx * GameState.y_shift)
			_spawn_object_at(tree_position, object_type)

func spawn_object_at_end(object_type, random_positions=false):
	var object = null
	if object_type == "RaceEnd":
		object = RaceEndScene.instantiate()
	elif object_type == "Ramp":
		object = RampScene.instantiate()
	elif object_type == "Stone":
		object = StoneScene.instantiate()
	elif object_type == "BiggerStone":
		object = BiggerStoneScene.instantiate()
	
	add_child(object)
	
	var col_idx = int(Constants.max_cols_per_screen / 2)
	var pos_x = col_idx * GameState.x_shift
	
	if random_positions:
		var x_variation_amount = Utils.random_sample_from_range(-object_spawn_x_variation, object_spawn_x_variation, 1)[0]
		col_idx = Utils.random_sample_from_range(col_idx - 1, col_idx + 1, 1)[0]
		pos_x = col_idx * GameState.x_shift + x_variation_amount
	
	var pos_y = Constants.max_rows_per_screen * GameState.y_shift
	object.global_position = Vector2(pos_x, pos_y)

func spawn_object_at_beggining(object_type, random_positions=false):
	var object = null
	if object_type == "Yeti":
		object = YetiScene.instantiate()
	elif object_type == "Avalanche":
		object = AvalancheScene.instantiate()
	
	add_child(object)
	
	var col_idx = int(Constants.max_cols_per_screen / 2)
	var pos_x = col_idx * GameState.x_shift
	
	if random_positions:
		var x_variation_amount = Utils.random_sample_from_range(-object_spawn_x_variation, object_spawn_x_variation, 1)[0]
		col_idx = Utils.random_sample_from_range(col_idx - 1, col_idx + 1, 1)[0]
		pos_x = col_idx * GameState.x_shift + x_variation_amount
	
	var pos_y = -1 * GameState.y_shift * (object.scale.y / 2)
	object.global_position = Vector2(pos_x, pos_y)
