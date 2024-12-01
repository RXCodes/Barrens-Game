class_name ScreenUI extends CanvasLayer
static var current: ScreenUI
static var overlayRect: ColorRect

func _ready() -> void:
	# half the viewport size
	offset = Vector2(640, 400)
	overlayRect = $OverlayRect
	current = self
	show()

static func hideUI() -> void:
	for child in current.get_children():
		child.hide()

## fades to black and then loads a specified scene
static func fadeToScene(scenePath: String) -> void:
	overlayRect.show()
	var shaderMaterial = overlayRect.material as ShaderMaterial
	shaderMaterial.set_shader_parameter("alpha", 0)
	overlayRect.color = Color(0, 0, 0, 0)
	var tween = NodeRelations.createTween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_method(setOverlayAlpha, 0.0, 1.0, 2.5)
	tween.parallel().tween_property(overlayRect, "color", Color(0, 0, 0, 1), 4.0)
	await TimeManager.wait(4.1)
	NodeRelations.loadScene(scenePath)

static func setOverlayAlpha(amount: float) -> void:
	var shaderMaterial = overlayRect.material as ShaderMaterial
	shaderMaterial.set_shader_parameter("alpha", amount)
