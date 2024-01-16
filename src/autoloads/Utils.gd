extends Node


func instance_scene_on_main(scene, location, init_params := {}):
	var main = get_tree().current_scene
	var instance = scene.instantiate()
	
	if init_params != {}:
		instance.init(init_params)
	
	main.add_child(instance)
	instance.global_position = location
	return instance

func random_sample_from_range(from, to, ammount):
	var arr = []
	if from < 0:
		for x in range(0, abs(from)):
			arr.append(-x)
		from = 0
	arr += Array(range(from, to))
	arr.shuffle()
	
	var samples = []
	while len(samples) < ammount:
		var arr_copy = arr.duplicate()
		for i in range(ammount):
			var value = arr_copy.pop_at(0)
			if value != null:
				samples.append(value)
	return samples

func get_viewport_center() -> Vector2:
	print(get_viewport().canvas_transform)
	return get_viewport().size / 2
