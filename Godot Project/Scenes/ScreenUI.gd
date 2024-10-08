class_name ScreenUI extends CanvasLayer
static var current

func _ready() -> void:
	offset = get_viewport().size * 0.5
	current = self
