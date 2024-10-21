@tool
extends ReferenceRect

@export var primaryColor: Color

# Called when the node enters the scene tree for the first time.
var stairs: NinePatchRect
func _ready() -> void:
	stairs = $Stairs
	updateStructure()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		updateStructure()

func updateStructure() -> void:
	stairs.size = scale * Vector2(34, 36)
	stairs.scale = Vector2.ONE / scale
	stairs.self_modulate = primaryColor
