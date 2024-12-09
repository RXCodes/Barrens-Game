class_name Crosshair extends Sprite2D
static var current: Crosshair
static var reloadingIcon: TextureProgressBar
static var hoveringOverButton: bool = false
static var popupCrosshair: Sprite2D

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
	popupCrosshair = $"../PopupCrosshair"
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

# move crosshair every frame
func _process(delta: float) -> void:
	if not PlayerCamera.current:
		return
	position = get_viewport().get_mouse_position()
	position -= get_viewport_rect().size / 2.0
	reloadingIcon.position = get_viewport().get_mouse_position() - Vector2(16, 16)
	reloadingIcon.position -= get_viewport_rect().size / 2.0
	cursorPosition = (position / PlayerCamera.current.zoom) + PlayerCamera.current.get_screen_center_position()
	
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
	
	# show a different crosshair while a popup is opened
	if reloading:
		return
	if GamePopup.current:
		popupCrosshair.position = current.position
		popupCrosshair.show()
		current.hide()
	else:
		popupCrosshair.hide()
		current.show()

static var reloadTimer: SceneTreeTimer
static var reloadTween: Tween
static var reloading: bool = false
static func reloadWeapon(time: float) -> void:
	if not is_instance_valid(current):
		return
	if reloadTween:
		reloadTween.kill()
	current.visible = false
	reloading = true
	reloadingIcon.visible = true
	reloadTween = NodeRelations.createTween()
	reloadingIcon.value = 0
	reloadingIcon.scale = Vector2(1.2, 1.2)
	reloadTween.tween_property(reloadingIcon, "value", 100, time).set_trans(Tween.TRANS_LINEAR)
	reloadTween.parallel().tween_property(reloadingIcon, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK)
	var newReloadTimer = TimeManager.waitTimer(time)
	reloadTimer = newReloadTimer
	await reloadTimer.timeout
	if reloadTimer != newReloadTimer:
		return
	stopReloadingWeapon()

static var stopReloadTween: Tween
static func stopReloadingWeapon() -> void:
	if not is_instance_valid(current):
		return
	reloading = false
	current.visible = true
	reloadingIcon.visible = false
	reloadTimer = null
	current.scale = Vector2(2.4, 2.4)
	stopReloadTween = NodeRelations.createTween()
	stopReloadTween.tween_property(current, "scale", Vector2(2.0, 2.0), 0.5).set_trans(Tween.TRANS_ELASTIC)
	if GamePopup.current:
		popupCrosshair.position = current.position
		popupCrosshair.show()
		current.hide()

static var fireTween: Tween
static func weaponFired() -> void:
	if stopReloadTween:
		stopReloadTween.stop()
	if fireTween:
		fireTween.stop()
	current.scale = Vector2(3.0, 3.0)
	fireTween = NodeRelations.createTween()
	fireTween.set_ease(Tween.EASE_OUT)
	fireTween.tween_property(current, "scale", Vector2(2.0, 2.0), 0.75).set_trans(Tween.TRANS_EXPO)

static var hitTween: Tween
static func enemyHit() -> void:
	if stopReloadTween:
		stopReloadTween.stop()
	if hitTween:
		hitTween.stop()
	current.self_modulate = Color.RED
	hitTween = NodeRelations.createTween()
	hitTween.set_ease(Tween.EASE_OUT)
	hitTween.tween_property(current, "self_modulate", Color.WHITE, 0.5).set_trans(Tween.TRANS_EXPO)

static func criticalHit() -> void:
	if stopReloadTween:
		stopReloadTween.stop()
	if hitTween:
		hitTween.stop()
	current.self_modulate = Color.GOLD
	hitTween = NodeRelations.createTween()
	hitTween.set_ease(Tween.EASE_OUT)
	hitTween.tween_property(current, "self_modulate", Color.WHITE, 2.0).set_trans(Tween.TRANS_EXPO)
