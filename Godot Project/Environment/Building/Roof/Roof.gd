@tool
extends ReferenceRect

@export var primaryColor: Color
@export var secondaryColor: Color
@export var roofFrontOffset: float = 5

# Called when the node enters the scene tree for the first time.
var roofTop: NinePatchRect
var roofFront: NinePatchRect
func _ready() -> void:
	roofTop = $RoofTop
	roofFront = $RoofFront
	updateStructure()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		updateStructure()

func updateStructure() -> void:
	roofTop.size = scale * Vector2(17, 10)
	roofTop.scale = Vector2.ONE / scale
	roofTop.self_modulate = primaryColor
	roofFront.size.x = scale.x * 17
	roofFront.size.y = 41 * 2
	roofFront.scale = Vector2.ONE / scale
	roofFront.self_modulate = secondaryColor
	roofFront.position.y = roofTop.size.y / scale.y
	roofFront.position.y -= roofFront.size.y / scale.y
	roofFront.position.y -= roofFrontOffset / scale.y
