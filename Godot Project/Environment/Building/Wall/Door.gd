@tool
extends Sprite2D

@export var frameColor: Color
@export var doorColor: Color

# Called when the node enters the scene tree for the first time.
var door: Sprite2D
func _ready() -> void:
	door = $Door
	updateStructure()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		updateStructure()

func updateStructure() -> void:
	self.scale = Vector2.ONE
	door.scale = self.scale
	self_modulate = frameColor
	door.self_modulate = doorColor
