extends Sprite2D
class_name Crosshair
static var current

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# show crosshair
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		position = event.position
