extends Node2D

var canBePickedUp = false
var pickupDistance = 75
var pickingUp = false
var pickupDuration = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Ammo.scale = Vector2.ZERO
	$AmmoShadow.scale = Vector2.ZERO
	$AnimationPlayer.speed_scale = randfn(1.0, 0.15)
	$AnimationPlayer.play("AmmoSpawn")
	var moveTween = NodeRelations.createTween()
	moveTween.set_ease(Tween.EASE_OUT)
	moveTween.set_trans(Tween.TRANS_CUBIC)
	var newPosition = global_position
	newPosition.x += randfn(0, 40)
	newPosition.y += randfn(0, 25)
	var tweenDuration = 1.0 / $AnimationPlayer.speed_scale
	moveTween.tween_property(self, "global_position", newPosition, tweenDuration)
	await TimeManager.wait(1.25)
	canBePickedUp = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if canBePickedUp:
		var distanceToPlayer = Player.current.global_position.distance_squared_to(global_position)
		if distanceToPlayer <= pickupDistance ** 2:
			pickup()
	if pickingUp:
		pickupAnimationProgress += delta / pickupDuration
		var targetPosition = Player.current.global_position + Vector2(0, -35)
		var newPosition = originalPosition.lerp(targetPosition, pickupAnimationProgress)
		global_position = newPosition
		$Ammo.rotation_degrees += (global_position.x - Player.current.global_position.x) * 0.125
		z_index = 4096
		if pickupAnimationProgress >= 1.0:
			Player.current.pickupAmmo()
			queue_free()

var pickupAnimationProgress = 0.0
var originalPosition: Vector2
func pickup() -> void:
	canBePickedUp = false
	pickingUp = true
	originalPosition = global_position
	$AnimationPlayer.play("AmmoPickup")
