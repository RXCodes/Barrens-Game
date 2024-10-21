@tool
extends ReferenceRect

@export var primaryColor: Color
@export var secondaryColor: Color

# Called when the node enters the scene tree for the first time.
var bottomFoundation: NinePatchRect
var topFoundation: NinePatchRect
var foundationWall: Sprite2D
var foundationWallOutline: Sprite2D
func _ready() -> void:
	bottomFoundation = $BottomFoundation
	topFoundation = $TopFoundation
	foundationWall = $FoundationWall
	foundationWallOutline = $FoundationWallOutline
	updateStructure()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		updateStructure()

func updateStructure() -> void:
	scale.y = 1
	bottomFoundation.size = scale * Vector2(17, 10)
	bottomFoundation.scale = Vector2.ONE / scale
	bottomFoundation.self_modulate = primaryColor
	topFoundation.size = scale * Vector2(17, 8)
	topFoundation.scale = Vector2.ONE / scale
	topFoundation.self_modulate = primaryColor
	foundationWall.scale = Vector2.ONE / scale
	foundationWall.self_modulate = secondaryColor
	var subdivisionWidth = 12
	var rectWidth = floor((scale.x * 17) / subdivisionWidth) - 1
	rectWidth = (rectWidth * subdivisionWidth) + 2
	foundationWall.region_rect = Rect2(Vector2.ZERO, Vector2(rectWidth, 22 * 2))
	foundationWall.offset.x = (scale.x * 17) / 2.0
	foundationWallOutline.scale = foundationWall.scale
	foundationWallOutline.offset.x = foundationWall.offset.x
	foundationWallOutline.region_rect = Rect2(Vector2.ZERO, Vector2(rectWidth + 4, 22 * 2))
