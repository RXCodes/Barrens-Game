class_name TextAlert extends Node2D

static var current: Node2D
static var description: Label
static var currentTween: Tween
static var audioPlayer: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	audioPlayer = $AudioStreamPlayer
	description = $Description
	current.modulate = Color.TRANSPARENT
	current.scale = Vector2(0.75, 0.75)

static func setupAlert(text: String, color: Color) -> void:
	if currentTween:
		currentTween.stop()
	current.modulate = Color.TRANSPARENT
	current.scale = Vector2(0.75, 0.75)
	audioPlayer.play()
	currentTween = NodeRelations.createTween()
	currentTween.set_ease(Tween.EASE_OUT)
	currentTween.set_trans(Tween.TRANS_EXPO)
	currentTween.tween_property(current, "modulate", color, 0.5)
	currentTween.parallel().tween_property(current, "scale", Vector2.ONE, 0.5)
	description.text = text
	currentTween.tween_property(current, "modulate", Color.TRANSPARENT, 2.0).set_delay(3.0)
