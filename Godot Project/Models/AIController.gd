extends Node2D
var canvasLayer: CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvasLayer = $CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#canvasLayer.offset = global_position
	pass
