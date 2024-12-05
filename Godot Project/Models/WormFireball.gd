class_name WormFireball extends Node2D

var targetPosition: Vector2
var maxDistance = 800
var travelTime = 1
var targetVelocity: Vector2
var wormType: EnemyAI.EnemyVariantType

var hasExploded = false
func explode() -> void:
	if hasExploded:
		return
	hasExploded = true
	
	# create explosion and change color based on enemy type
	var color = Color("#7cb5eb")
	if wormType == EnemyAI.EnemyVariantType.ACID:
		color = Color("#10ed00")
	if wormType == EnemyAI.EnemyVariantType.LIGHTNING:
		color = Color("#ffe100")
	if wormType == EnemyAI.EnemyVariantType.INFERNO:
		color = Color("#ff0000")
	
	var explosion = Explosion.create($RigidBody2D/Fireball.global_position, 20, EnemyAI.HurtBoxType.PLAYER, color)
	queue_free()

# determines the trajectory of the fireball - assume this is called on start as intended
func goToPosition(newTargetPosition: Vector2) -> void:
	$SmokeStart.emitting = true
	$RigidBody2D/AnimationPlayer.play("Summon")
	var distance = global_position.distance_to(newTargetPosition)
	var normal = (newTargetPosition - global_position).normalized()
	var trajectory = normal * min(distance, maxDistance)
	targetPosition = global_position + trajectory
	targetVelocity = (targetPosition - global_position) / travelTime
	await TimeManager.wait(travelTime)
	explode()
	
func _physics_process(delta: float) -> void:
	$RigidBody2D/Fireball.rotation_degrees += delta * 700
	var collision = $RigidBody2D.move_and_collide(targetVelocity * delta)
	if collision:
		var collider = collision.get_collider()
		if not collider.has_meta(EnemyAI.parentControllerKey):
			explode()
		else:
			$RigidBody2D.add_collision_exception_with(collider)
