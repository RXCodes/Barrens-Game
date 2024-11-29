class_name HurtVignette extends NinePatchRect

static var current: HurtVignette

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self

static var currentTween: Tween
static func animate(opacity: float, time: float) -> void:
	if currentTween:
		currentTween.stop()
	current.self_modulate = Color(1, 0, 0, opacity)
	currentTween = NodeRelations.createTween()
	currentTween.set_ease(Tween.EASE_OUT)
	currentTween.set_trans(Tween.TRANS_EXPO)
	currentTween.tween_property(current, "self_modulate", Color(1, 0, 0, 0), time)
