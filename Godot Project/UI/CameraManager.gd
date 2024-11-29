class_name PlayerCamera extends Camera2D
static var current: PlayerCamera

var crosshairZoomOffset = 0.0
var sprintingZoomOffset = 0.0
var originalZoom = 0.9
var zoomMultiplier = 1.0

var aimingPositionOffset = Vector2.ZERO
var originalPositionOffset = Vector2.ZERO
var gunFireShakeOffset = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# zoom camera
	var finalZoom = originalZoom
	finalZoom *= 1.0 + crosshairZoomOffset
	finalZoom *= 1.0 + sprintingZoomOffset
	finalZoom *= zoomMultiplier
	zoom = Vector2(finalZoom, finalZoom)
	
	# offset camera
	var finalOffset = originalPositionOffset
	finalOffset += aimingPositionOffset
	finalOffset += gunFireShakeOffset
	finalOffset.y += verticalOffsetShake
	offset = finalOffset
	
func setZoom(zoom: float, duration: float) -> void:
	var tween = NodeRelations.createTween()
	tween.tween_property(current, "originalZoom", zoom, duration).set_trans(Tween.TRANS_CUBIC)
	tween.play()

func setOffset(offset: Vector2, duration: float) -> void:
	var tween = NodeRelations.createTween()
	tween.tween_property(current, "originalPositionOffset", offset, duration).set_trans(Tween.TRANS_CUBIC)
	tween.play()

var verticalOffsetShake = 0.0
var verticalShakeTween: Tween
func playerDamaged() -> void:
	verticalOffsetShake = -15
	if verticalShakeTween:
		verticalShakeTween.stop()
	verticalShakeTween = NodeRelations.createTween()
	verticalShakeTween.set_ease(Tween.EASE_OUT)
	verticalShakeTween.set_trans(Tween.TRANS_ELASTIC)
	verticalShakeTween.tween_property(self, "verticalOffsetShake", 0, 1.5)
