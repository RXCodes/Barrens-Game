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
	updateStructure()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		updateStructure()

func updateStructure() -> void:
	roofTop.size = scale * Vector2(17, 10)
	roofTop.scale = Vector2.ONE / scale
	roofTop.self_modulate = primaryColor
