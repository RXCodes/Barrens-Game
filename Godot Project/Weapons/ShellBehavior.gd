extends Node2D

# Called when the node enters the scene tree for the first time.
var xPosition = 0
var yPosition = 0
func _ready() -> void:
	xPosition = global_position.x
	yPosition = global_position.y
	set_meta(ZIndexSorter.zScoreKey, yPosition)
	var xTween = get_tree().create_tween()
	xTween.tween_property(self, "xPosition", xPosition + randfn(0, 20), 0.3)
	xTween.set_ease(Tween.EASE_OUT)
	var yTween = get_tree().create_tween()
	yTween.tween_property(self, "yPosition", yPosition - randfn(25, 5), 0.2)
	yTween.set_ease(Tween.EASE_OUT)
	yTween.tween_property(self, "yPosition", yPosition + randfn(60, 10), 0.15)
	yTween.set_ease(Tween.EASE_IN)
	rotation_degrees = randf_range(-10, 10)
	var rotateTween = get_tree().create_tween()
	rotateTween.tween_property(self, "rotation_degrees",  randf_range(-150, 150), 0.45)
	rotateTween.set_ease(Tween.EASE_OUT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
var decayTime = randf_range(3.5, 6.0)
func _process(delta: float) -> void:
	global_position = Vector2(xPosition, yPosition)
	if decaying:
		return
	decayTime -= delta
	if decayTime <= 0:
		decaying = true
		decay()

var decaying = false
func decay() -> void:
	var decayTween = get_tree().create_tween()
	decayTween.tween_property(self, "scale", Vector2.ZERO, 0.4)
	decayTween.set_ease(Tween.EASE_OUT)
	decayTween.tween_callback(queue_free)
