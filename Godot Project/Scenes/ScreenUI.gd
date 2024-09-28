class_name ScreenUI extends Control
static var current

func _ready() -> void:
	current = self

# Make sure the position and scale of the UI matches the camera
func _process(delta: float) -> void:
	position = PlayerCamera.current.get_screen_center_position()
	scale = Vector2.ONE / PlayerCamera.current.zoom
