class_name ScreenUI extends CanvasLayer
static var current: ScreenUI

func _ready() -> void:
	# half the viewport size
	offset = Vector2(640, 400)
	current = self
	show()

static func hideUI() -> void:
	for child in current.get_children():
		child.hide()
