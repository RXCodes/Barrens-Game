class_name StoryboardImage extends Sprite2D

static var current: Sprite2D
static var currentTween: Tween
static var flash: ColorRect
static var animationPlayer: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	self_modulate = Color.TRANSPARENT
	flash = $Flash
	animationPlayer = $AnimationPlayer

static func fadeIn(duration: float) -> void:
	if currentTween:
		currentTween.stop()
	current.self_modulate = Color.TRANSPARENT
	currentTween = NodeRelations.createTween()
	currentTween.tween_property(current, "self_modulate", Color.WHITE, duration)

static func fadeOut(duration: float) -> void:
	if currentTween:
		currentTween.stop()
	currentTween = NodeRelations.createTween()
	currentTween.tween_property(current, "self_modulate", Color.TRANSPARENT, duration)

static func setTexture(newTexture: Texture2D) -> void:
	current.texture = newTexture

static func flashColor(color: Color, duration: float) -> void:
	flash.self_modulate = color
	var tween = NodeRelations.createTween()
	tween.tween_property(flash, "self_modulate", Color.TRANSPARENT, duration)

static func shake() -> void:
	animationPlayer.play("shake")
