extends Label

var time = 0


func _process(delta):
	if GameState.game_paused:
		return
	
	time += delta
	var mils = fmod(time, 1) * 100
	var secs = fmod(time, 60)
	var mins = fmod(time, 60*60) / 600
	
	var time_passed = "%02d : %02d : %02d" % [mins, secs, mils]
	text = time_passed
	
	GameState.total_time = time
