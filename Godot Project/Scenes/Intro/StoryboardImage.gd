class_name StoryboardImage extends Sprite2D

static var current: Sprite2D
static var currentTween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	self_modulate = Color.TRANSPARENT

static func fadeIn(duration: float) -> void:
	if currentTween:
		currentTween.stop()
	currentTween = NodeRelations.createTween()
	currentTween.tween_property(current, "self_modulate", Color.WHITE, duration)

static func fadeOut(duration: float) -> void:
	if currentTween:
		currentTween.stop()
	currentTween = NodeRelations.createTween()
	currentTween.tween_property(current, "self_modulate", Color.TRANSPARENT, duration)
