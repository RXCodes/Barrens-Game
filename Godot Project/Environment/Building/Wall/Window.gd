@tool
extends Sprite2D

enum WindowType {ONE, TWO, THREE, FOUR}
@export var windowType: WindowType = WindowType.ONE

@export var frameColor: Color
@export var windowColor: Color

# Called when the node enters the scene tree for the first time.
var window: Sprite2D
var highlight: Sprite2D
func _ready() -> void:
	window = $Window
	highlight = $Highlight
	updateStructure()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		updateStructure()

func updateStructure() -> void:
	self.scale = Vector2.ONE
	window.scale = self.scale
	self_modulate = frameColor
	window.self_modulate = windowColor
	
	var type = "1"
	if windowType == WindowType.TWO:
		type = "2"
	if windowType == WindowType.THREE:
		type = "3"
	if windowType == WindowType.FOUR:
		type = "4"
	
	self.texture = ResourceLoader.load("res://Environment/Building/Wall/Window" + type + ".png")
	window.texture = ResourceLoader.load("res://Environment/Building/Wall/Glass" + type + ".png")
	highlight.texture = ResourceLoader.load("res://Environment/Building/Wall/GlassHighlight" + type + ".png")
