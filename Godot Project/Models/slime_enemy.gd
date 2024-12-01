extends EnemyAI
class_name BaseSlimeEnemy
 
var canDealDamage = false

# Function called when the enemy spawns into the scene
func onStart() -> void:
	setTarget(Player.current, 100)
	while not dead:
		walkMovementSpeed = 2
		await enemyReachedTarget
		
		# enemy jumps towards the player while in range
		while withinRangeOfTarget():
			canDealDamage = true
			faceTarget()
			walkMovementSpeed = 0  
			mainAnimationPlayer.stop()
			playAnimation("Attack")
			await TimeManager.wait(0.2)
			canDealDamage = true
			jumpToPoint(getTargetPosition(), 0.5)
			await TimeManager.wait(0.5)
			if canDealDamage:
				activateHurtBox($ColliderBox/Hurtbox,  randf_range(3, 5), HurtBoxType.PLAYER)
			await enemyAnimationFinished
			await TimeManager.wait(0.02)
		await TimeManager.wait(0.02)

var jumpNormal: Vector2
var jumping = false
# jumps towards a position with given air time
func jumpToPoint(position: Vector2, airTime: float) -> void:
	jumpNormal = (position - getPosition()).normalized()
	jumping = true
	await TimeManager.wait(airTime)
	jumping = false

func physicsProcess(delta: float) -> void:
	if not jumping:
		return
	# move the slime as it is jumping
	var result = collisionRigidBody.move_and_collide(jumpNormal * 5.0)
	if result:
		# stop the slime from moving any more when it hits an obstacle and deal damage
		activateHurtBox($ColliderBox/Hurtbox,  randf_range(3, 5), HurtBoxType.PLAYER)
		canDealDamage = false
		jumping = false
