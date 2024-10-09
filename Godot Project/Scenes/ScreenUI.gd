class_name ScreenUI extends CanvasLayer
static var current

func _ready() -> void:
	# half the viewport size
	offset = Vector2(640, 400)
	current = self
