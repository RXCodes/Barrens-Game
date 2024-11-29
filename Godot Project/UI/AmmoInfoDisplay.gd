class_name AmmoInfoDisplay extends Control

static var ammoLeft: Label
static var magCapacity: Label
static var current: Control
static var initialPosition: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ammoLeft = $AmmoLeft
	magCapacity = $MagCapacity
	current = self
	initialPosition = current.position

static func setAmmoLeft(amount: int) -> void:
	if not ammoLeft:
		return
	ammoLeft.text = str(amount)
	if amount <= 0:
		ammoLeft.self_modulate = Color(1.0, 0.25, 0.25, 1.0)
	else:
		ammoLeft.self_modulate = Color.WHITE

static func setMagCapacity(amount: int) -> void:
	magCapacity.text = str(amount)
	if amount <= 0:
		magCapacity.self_modulate = Color(1.0, 0.25, 0.25, 1.0)
	else:
		magCapacity.self_modulate = Color.WHITE

static var previousGunfireTween: Tween
static func gunFired() -> void:
	magCapacity.scale = Vector2(2.5, 2.5)
	if previousGunfireTween:
		previousGunfireTween.kill()
	previousGunfireTween = current.get_tree().create_tween()
	previousGunfireTween.tween_property(magCapacity, "scale", Vector2(1.5, 1.5), 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	previousGunfireTween.play()

static func gunReloaded() -> void:
	ammoLeft.scale = Vector2(2.0, 2.0)
	magCapacity.scale = Vector2(2.0, 2.0)
	var tween = current.get_tree().create_tween()
	tween.tween_property(ammoLeft, "scale", Vector2(1.5, 1.5), 0.5).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(magCapacity, "scale", Vector2(1.5, 1.5), 0.5).set_trans(Tween.TRANS_ELASTIC)
	tween.play()
	
	var bounceTween = current.get_tree().create_tween()
	bounceTween.tween_property(current, "position", initialPosition + Vector2(0, -10), 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	bounceTween.tween_property(current, "position", initialPosition, 0.5).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	bounceTween.play()
