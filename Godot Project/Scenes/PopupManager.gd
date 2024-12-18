class_name GamePopup extends Node2D

static var current: GamePopup
var open = true
var background: ColorRect
var tween: Tween
var data: Dictionary
signal popupClosedLocal
static var popupClosed: Signal

## used in tutorial scene - quiets the ambience when the popup is enabled
@export var silencesAmbience = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background = $".."
	background.modulate = Color.TRANSPARENT
	if OS.has_feature("web"):
		background.material = null
	scale = Vector2(0.9, 0.9)
	await get_tree().physics_frame
	tween = NodeRelations.createTween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(background, "modulate", Color.WHITE, 0.6)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, 0.6)
	popupClosed = popupClosedLocal
	if silencesAmbience:
		tween.parallel().tween_property(InGameAmbience.current, "volume_db", -20, 0.6)

func _process(delta: float) -> void:
	var shaderMaterial = background.material as ShaderMaterial
	if shaderMaterial:
		shaderMaterial.set_shader_parameter("alpha", background.modulate.a)

static func closeCurrent() -> void:
	if not is_instance_valid(current):
		return
	if not current.open:
		return
	popupClosed.emit()
	var closeSound = current.background.find_child("Close")
	if closeSound and closeSound is AudioStreamPlayer:
		closeSound.play()
	current.open = false
	if current.tween:
		current.tween.stop()
	current.tween = NodeRelations.createTween()
	current.tween.set_ease(Tween.EASE_OUT)
	current.tween.set_trans(Tween.TRANS_EXPO)
	current.tween.tween_property(current.background, "modulate", Color.TRANSPARENT, 0.6)
	current.tween.parallel().tween_property(current, "scale", Vector2(0.9, 0.9), 0.6)
	if current.silencesAmbience:
		current.tween.parallel().tween_property(InGameAmbience.current, "volume_db", -6, 0.6)
	current.tween.tween_callback(current.background.queue_free)
	current = null

static func openPopup(name: String, data: Dictionary = {}) -> void:
	if current:
		closeCurrent()
	var popupScene = load("res://UI/Popups/" + name + ".tscn")
	var popup = popupScene.instantiate()
	var screenUI = NodeRelations.rootNode.find_child("ScreenUI")
	current = popup.get_children()[0]
	current.data = data
	screenUI.add_child(popup)
