class_name BulletShell extends Sprite2D

# Called when the node enters the scene tree for the first time.
var xPosition = 0
var yPosition = 0
var xVelocity: float = 0
func _ready() -> void:
	texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	xPosition = global_position.x
	yPosition = global_position.y
	set_meta(ZIndexSorter.zScoreKey, yPosition + 50)
	var xTween = NodeRelations.createTween()
	xTween.tween_property(self, "xPosition", xPosition + randfn(xVelocity, 15), 0.4)
	xTween.set_ease(Tween.EASE_OUT)
	xTween.set_trans(Tween.TRANS_CIRC)
	var yTween = NodeRelations.createTween()
	yTween.tween_property(self, "yPosition", yPosition - randfn(25, 5), 0.2)
	yTween.set_ease(Tween.EASE_OUT)
	yTween.tween_property(self, "yPosition", yPosition + randfn(60, 10), 0.15)
	yTween.set_ease(Tween.EASE_IN)
	yTween.set_trans(Tween.TRANS_BACK)
	rotation_degrees = randf_range(-10, 10)
	var rotateTween = NodeRelations.createTween()
	rotateTween.tween_property(self, "rotation_degrees",  randf_range(-150, 150), 0.45)
	rotateTween.set_ease(Tween.EASE_OUT)
	await TimeManager.wait(randf_range(1.0, 2.5))
	decay()

func _process(delta: float) -> void:
	global_position = Vector2(xPosition, yPosition)

func decay() -> void:
	var decayTween = NodeRelations.createTween()
	decayTween.tween_property(self, "scale", Vector2.ZERO, 0.4)
	decayTween.set_ease(Tween.EASE_OUT)
	decayTween.tween_callback(queue_free)
