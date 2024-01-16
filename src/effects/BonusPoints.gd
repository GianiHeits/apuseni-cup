extends Marker2D

var points = 200

func init(init_vals):
	points = init_vals["points"]

func _ready():
	$Points.text = "+ %s"%points
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(), 1)
	tween.tween_callback(self.queue_free)
