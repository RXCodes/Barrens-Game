extends EnemyAI
class_name ScorpionEnemy

var canDash = false
var dashing = false
var dashNormal: Vector2
signal dashComplete

# Function called when the enemy spawns into the scene
func onStart() -> void:
	dashLoop()
	var wave = VillageController.currentWave
	var shapeCast: ShapeCast2D = $ColliderBox/ShapeCast2D
	shapeCast.add_exception($Hitbox)
	# Loop this while the enemy is alive
	while not dead:
		
		# slowly travel towards the player
		$ColliderBox/FlipTransform/Animations.play("Idle")
		walkMovementSpeed = 2
		walkMovementSpeed = 2 * (1 + (wave - 6) * 0.05)
		walkMovementSpeed = min(walkMovementSpeed, 3)
		await enemyReachedTarget
		
		# dash towards the player if needed
		if canDash:
			var trajectoryLength = 600
			var trajectory = (getTargetPosition() - getPosition()).normalized() * trajectoryLength
			
			# check if the scorpion can even get to the target
			shapeCast.target_position = trajectory
			var shouldDash = true
			if shapeCast.is_colliding():
				shouldDash = false
				for i in range(shapeCast.get_collision_count()):
					var collider = shapeCast.get_collider(i)
					if collider is Player:
						shouldDash = true
						break
			
			if shouldDash:
				walkMovementSpeed = 0
				await animateBrightness(0.5, 0.2)
				await animateBrightness(0, 0.2)
				await animateBrightness(0.5, 0.2)
				await animateBrightness(0, 0.2)
				dashTowardsPosition(getTargetPosition())
				await dashComplete
				activateHurtBox($ColliderBox/Hurtbox, randf_range(25, 35), HurtBoxType.PLAYER)
				$ColliderBox/FlipTransform/Animations.stop()
				await TimeManager.wait(0.5)
			else:
				canDash = false
		
		# Make the enemy attack while in range of the player
		while withinDistanceOfTarget(100):
			faceTarget()
			$ColliderBox/FlipTransform/Animations.play("Attack")
			await TimeManager.wait(.3)
			activateHurtBox($ColliderBox/Hurtbox, randf_range(18, 25), HurtBoxType.PLAYER)
			await TimeManager.wait(.7)

# dash at random times
func dashLoop() -> void:
	while not dead:
		var wave = VillageController.currentWave
		var cooldownScorpion = (randf_range(4.0, 8.0))
		cooldownScorpion /= 1 + (wave * .05)
		cooldownScorpion = max(cooldownScorpion, 2)
		await TimeManager.wait(cooldownScorpion)
		canDash = true

# dash towards a point
func dashTowardsPosition(position: Vector2) -> void:
	canDash = false
	dashNormal = (position - getPosition()).normalized()
	$ColliderBox/Shape.scale = Vector2(2, 2)
	dashing = true
	await TimeManager.wait(0.8)
	$ColliderBox/Shape.scale = Vector2(1, 1)
	dashComplete.emit()
	dashing = false

func physicsProcess(delta: float) -> void:
	if canDash:
		setTarget(Player.current, 600)
	else:
		setTarget(Player.current, 100)
	if dashing:
		# dash until it hits the player or a wall
		var result: KinematicCollision2D = collisionRigidBody.move_and_collide(dashNormal * 12.5)
		if result:
			var collider = result.get_collider()
			if collider.has_meta(EnemyAI.parentControllerKey):
				collider = collider.get_meta(EnemyAI.parentControllerKey)
			if collider is Player or collider is not EnemyAI:
				$ColliderBox/Shape.scale = Vector2(1, 1)
				dashComplete.emit()
				dashing = false
