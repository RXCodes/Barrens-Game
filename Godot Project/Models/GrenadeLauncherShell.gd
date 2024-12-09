class_name GrenadeLauncherShell extends Node2D

var targetPosition: Vector2
var maxDistance = 800
var travelTime = 1.25
var targetVelocity: Vector2

func _ready() -> void:
	# play projectile animation
	$RigidBody2D/AnimationPlayer.play("Summon")
	await TimeManager.wait(0.75)
	explode()

var hasExploded = false
func explode() -> void:
	if hasExploded:
		return
	hasExploded = true
	# create explosion
	var explosion = Explosion.create($RigidBody2D/Grenade.global_position, 120 * Player.current.gunInteractor.damageMultiplier, EnemyAI.HurtBoxType.ENEMY)
	explosion.isFromPlayer = true
	# hurt the player too
	Explosion.create($RigidBody2D/Grenade.global_position, 30, EnemyAI.HurtBoxType.PLAYER)
	queue_free()

# determines the trajectory of the grenade
func goToPosition(newTargetPosition: Vector2) -> void:
	var distance = global_position.distance_to(newTargetPosition)
	var normal = (newTargetPosition - global_position).normalized()
	var trajectory = normal * min(distance, maxDistance)
	targetPosition = global_position + trajectory
	targetVelocity = (targetPosition - global_position) * 3.0 / travelTime
	
func _physics_process(delta: float) -> void:
	var rigidBody: RigidBody2D = $RigidBody2D
	$RigidBody2D/Grenade.rotation_degrees += delta * targetVelocity.x * 2
	targetVelocity *= 0.98 # damp the target velocity for smoother deceleration
	var collision = rigidBody.move_and_collide(targetVelocity * delta)
	# the grenade cannot move anymore once it hits a wall
	if collision:
		var collider = collision.get_collider()
		if not collider.has_meta(EnemyAI.parentControllerKey):
			explode()
		else:
			rigidBody.add_collision_exception_with(collider)
