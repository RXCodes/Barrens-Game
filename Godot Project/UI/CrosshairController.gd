class_name Crosshair extends TextureRect
static var current: Control
static var reloadingIcon: TextureProgressBar

var cameraOffsetDampening = 0.1
var cameraOffsetMultiplier = 0.2
var maximumOffsetDistance = 100
var zoomMultiplier = 1.0 / 350.0
var minimumDistanceToZoom = 50
var zoomDampening = 0.05
var cursorPosition = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	reloadingIcon = $"../ReloadingIcon"
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# move crosshair every frame
func _process(delta: float) -> void:
	position = get_viewport().get_mouse_position() - (size / 2.0)
	position -= get_viewport_rect().size / 2.0
	reloadingIcon.position = get_viewport().get_mouse_position() - (reloadingIcon.size / 2.0)
	reloadingIcon.position += Vector2(4, 4)
	reloadingIcon.position -= get_viewport_rect().size / 2.0
	cursorPosition = global_position + PlayerCamera.current.get_screen_center_position()
	
	# offset camera depending on vector from player
	var targetOffset = (cursorPosition - Player.current.global_position) * cameraOffsetMultiplier
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

static var reloadTimer: SceneTreeTimer
static var reloadTween: Tween
static func reloadWeapon(time: float) -> void:
	if reloadTween:
		reloadTween.kill()
	current.visible = false
	reloadingIcon.visible = true
	reloadTween = NodeRelations.createTween()
	reloadingIcon.value = 0
	reloadingIcon.scale = Vector2(1.25, 1.25)
	reloadTween.tween_property(reloadingIcon, "value", 100, time).set_trans(Tween.TRANS_LINEAR)
	reloadTween.parallel().tween_property(reloadingIcon, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK)
	reloadTween.play()
	var newReloadTimer = TimeManager.waitTimer(time)
	reloadTimer = newReloadTimer
	await reloadTimer.timeout
	if reloadTimer != newReloadTimer:
		return
	stopReloadingWeapon()

static func stopReloadingWeapon() -> void:
	current.visible = true
	reloadingIcon.visible = false
	reloadTimer = null
	current.scale = Vector2(1.2, 1.2)
	var tween = NodeRelations.createTween()
	tween.tween_property(current, "scale", Vector2.ONE, 0.5).set_trans(Tween.TRANS_ELASTIC)
	tween.play()
