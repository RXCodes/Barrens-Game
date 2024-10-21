@tool
extends ReferenceRect

@export var primaryColor: Color

# Called when the node enters the scene tree for the first time.
var support: NinePatchRect
func _ready() -> void:
	support = $Support
	updateStructure()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		updateStructure()

func updateStructure() -> void:
	scale.x = 2
	support.size = scale * Vector2(5, 31)
	support.scale = Vector2.ONE / scale
	support.self_modulate = primaryColor
