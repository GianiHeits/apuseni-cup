extends LineEdit


func _on_PlayerName_focus_entered():
	if OS.has_feature('JavaScript') and OS.get_name() in ["Android", "iOS"]:
		text = JavaScript.eval("""
			window.prompt('Your Name')
		""")
