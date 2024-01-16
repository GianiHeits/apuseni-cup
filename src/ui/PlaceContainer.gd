extends HBoxContainer

var label = null setget _set_label, _get_label
var score = null setget _set_score, _get_score

func _set_label(text):
	label = text
	$"%PlaceLabel".text = str(text)

func _get_label():
	return label

func _set_score(text):
	score = text
	$"%PlaceValue".text = str(text)

func _get_score():
	return score
