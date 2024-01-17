extends LineEdit


func _on_PlayerName_focus_entered():
	if OS.has_feature('JavaScript'):
		text = JavaScript.eval("""
			window.prompt('Your Name')
		""")
