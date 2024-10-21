@tool
extends ReferenceRect

@export var primaryColor: Color

# Called when the node enters the scene tree for the first time.
var floor: NinePatchRect
var vignette: NinePatchRect
func _ready() -> void:
	floor = $Floor
	vignette = $Vignette
	updateStructure()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		updateStructure()

func updateStructure() -> void:
	floor.size = scale * Vector2(37, 31)
	floor.scale = Vector2.ONE / scale
	floor.self_modulate = primaryColor
	vignette.size = scale * Vector2(37, 31)
	vignette.scale = Vector2.ONE / scale
