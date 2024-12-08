class_name Grenade extends Node2D

var targetPosition: Vector2
var maxDistance = 800
var travelTime = 1.25
var canTravel = true
var targetVelocity: Vector2

func _ready() -> void:
	# play rolling animation
	$RigidBody2D/AnimationPlayer.play("Summon")
	var highlight = $RigidBody2D/Grenade/Highlight
	await TimeManager.wait(0.75)
	for i in range(3):
		var tween = NodeRelations.createTween()
		tween.tween_property(highlight, "modulate", Color.WHITE, 0.1)
		tween.tween_property(highlight, "modulate", Color.TRANSPARENT, 0.1)
		await TimeManager.wait(0.2)
	
	# create explosion
	var explosion = Explosion.create($RigidBody2D/Grenade.global_position, 250 * Player.current.gunInteractor.damageMultiplier, EnemyAI.HurtBoxType.ENEMY)
	explosion.isFromPlayer = true
	# hurt the player too
	Explosion.create($RigidBody2D/Grenade.global_position, 30, EnemyAI.HurtBoxType.PLAYER)
	queue_free()

# determines the trajectory of the grenade
func goToPosition(newTargetPosition: Vector2) -> void:
	canTravel = true
	var distance = global_position.distance_to(newTargetPosition)
	var normal = (newTargetPosition - global_position).normalized()
	var trajectory = normal * min(distance, maxDistance)
	targetPosition = global_position + trajectory
	targetVelocity = (targetPosition - global_position) * 2.0 / travelTime
	await TimeManager.wait(travelTime)
	canTravel = false
	
func _physics_process(delta: float) -> void:
	if not canTravel:
		return
	var rigidBody: RigidBody2D = $RigidBody2D
	$RigidBody2D/Grenade.rotation_degrees += delta * targetVelocity.x * 2
	targetVelocity *= 0.98 # damp the target velocity for smoother deceleration
	var collision = rigidBody.move_and_collide(targetVelocity * delta)
	# the grenade cannot move anymore once it hits a wall
	if collision:
		var collider = collision.get_collider()
		if not collider.has_meta(EnemyAI.parentControllerKey):
			canTravel = false
		else:
			rigidBody.add_collision_exception_with(collider)
