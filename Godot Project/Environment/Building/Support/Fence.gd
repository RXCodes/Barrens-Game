@tool
extends ReferenceRect

@export var primaryColor: Color
@export var secondaryColor: Color

enum FenceType {ONE, TWO, THREE}
@export var fenceType: FenceType

@export var showLeftFencePole: bool = true
@export var showRightFencePole: bool = true

# Called when the node enters the scene tree for the first time.
var fence: Sprite2D
var leftFencePole: Sprite2D
var rightFencePole: Sprite2D
func _ready() -> void:
	fence = $Fence
	leftFencePole = $LeftFencePole
	rightFencePole = $RightFencePole
	updateStructure()
	updateSprite()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		updateStructure()
		updateSprite()

func updateStructure() -> void:
	scale.y = 1
	fence.self_modulate = primaryColor
	leftFencePole.self_modulate = secondaryColor
	rightFencePole.self_modulate = secondaryColor
	fence.scale = Vector2.ONE / scale
	leftFencePole.scale = Vector2.ONE / scale
	rightFencePole.scale = Vector2.ONE / scale
	var subdivisionWidth = 54
	var rectWidth = floor((scale.x * 17) / subdivisionWidth) - 1
	rectWidth = (rectWidth * subdivisionWidth) + 2
	fence.region_rect = Rect2(Vector2.ZERO, Vector2(rectWidth, 24 * 2))
	fence.offset.x = rectWidth / 2.0
	rightFencePole.offset.x = leftFencePole.offset.x + rectWidth + 6
	rightFencePole.position.x = 0
	leftFencePole.visible = showLeftFencePole
	rightFencePole.visible = showRightFencePole

func updateSprite() -> void:
	if fenceType == FenceType.ONE:
		fence.texture = preload("res://Environment/Building/Support/Fence1.png")
	if fenceType == FenceType.TWO:
		fence.texture = preload("res://Environment/Building/Support/Fence2.png")
	if fenceType == FenceType.THREE:
		fence.texture = preload("res://Environment/Building/Support/Fence3.png")
