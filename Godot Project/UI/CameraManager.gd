class_name PlayerCamera extends Camera2D
static var current: PlayerCamera

var crosshairZoomOffset = 0.0
var sprintingZoomOffset = 0.0
var originalZoom = 1.0

var aimingPositionOffset = Vector2.ZERO
var originalPositionOffset = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# zoom camera
	var finalZoom = originalZoom
	finalZoom *= 1.0 + crosshairZoomOffset
	finalZoom *= 1.0 + sprintingZoomOffset
	zoom = Vector2(finalZoom, finalZoom)
	
	# offset camera
	var finalOffset = originalPositionOffset
	finalOffset += aimingPositionOffset
	offset = finalOffset
	
func setZoom(zoom: float, duration: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(current, "originalZoom", zoom, duration).set_trans(Tween.TRANS_CUBIC)
	tween.play()

func setOffset(offset: Vector2, duration: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(current, "originalPositionOffset", offset, duration).set_trans(Tween.TRANS_CUBIC)
	tween.play()
