class_name MolotovCocktail extends Node2D

var targetPosition: Vector2
var maxDistance = 800
var travelTime = 1.25
var canTravel = true
var targetVelocity: Vector2

func _ready() -> void:
	# play rolling animation
	$RigidBody2D/AnimationPlayer.play("Summon")
	var highlight = $RigidBody2D/Grenade/Highlight
	await TimeManager.wait(1.0)
	
	# create burning area
	var molotoveFire = MolotovFire.create($RigidBody2D/Molotov.global_position, 40 * Player.current.gunInteractor.damageMultiplier, EnemyAI.HurtBoxType.ENEMY)
	molotoveFire.isFromPlayer = true
	$RigidBody2D/Molotov.self_modulate = Color.TRANSPARENT
	$RigidBody2D/Shadow.queue_free()
	await TimeManager.wait(2.0)
	queue_free()

# determines the trajectory of the molotov
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
	$RigidBody2D/Molotov.rotation_degrees += delta * targetVelocity.x * 2
	targetVelocity *= 0.98 # damp the target velocity for smoother deceleration
	var collision = $RigidBody2D.move_and_collide(targetVelocity * delta)
	# the molotov cannot move anymore once it hits a wall
	if collision:
		canTravel = false
