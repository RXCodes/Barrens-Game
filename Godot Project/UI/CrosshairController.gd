extends Sprite2D
class_name Crosshair
static var current
static var crosshairPosition = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# move crosshair every frame
func _process(delta: float) -> void:
	position = crosshairPosition - get_viewport_transform().get_origin()

# update crosshair position when the mouse moves
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		crosshairPosition = event.position
