class_name Crosshair extends TextureRect
static var current

var cameraOffsetDampening = 0.1
var cameraOffsetMultiplier = 0.2
var maximumOffsetDistance = 100
var zoomMultiplier = 1.0 / 350.0
var minimumDistanceToZoom = 50
var zoomDampening = 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# move crosshair every frame
func _process(delta: float) -> void:
	position = get_viewport().get_mouse_position() - (size / 2.0)
	position -= get_viewport_rect().size / 2.0
	
	# offset camera depending on vector from player
	var targetOffset = (global_position - Player.current.global_position) * cameraOffsetMultiplier
	if targetOffset.length_squared() >= maximumOffsetDistance ** 2:
		targetOffset = targetOffset.normalized() * maximumOffsetDistance
	PlayerCamera.current.aimingPositionOffset += (targetOffset - PlayerCamera.current.aimingPositionOffset) * cameraOffsetDampening
	
	# zoom depending on distance from player
	var targetZoomOffset: float
	if targetOffset.length_squared() <= minimumDistanceToZoom ** 2:
		targetZoomOffset = 0.0
	else:
		targetZoomOffset = -(targetOffset.length() - minimumDistanceToZoom) * zoomMultiplier
	PlayerCamera.current.crosshairZoomOffset += (targetZoomOffset - PlayerCamera.current.crosshairZoomOffset) * zoomDampening
