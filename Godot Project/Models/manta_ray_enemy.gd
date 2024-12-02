extends EnemyAI
class_name MantaRayEnemy

var player: Node2D
var dashing = false
var dashNormal: Vector2
var pathfindNormal: bool

signal hitWithDash

# Function called when the enemy spawns into the scene
func onStart() -> void:
	var wave = VillageController.currentWave
	# Loop this while the enemy is alive
	while not dead:
		# get within range to dash to player
		walkMovementSpeed = 2.5
		walkMovementSpeed = 2.5 * (1 + (wave - 4) * 0.05)
		walkMovementSpeed = min(walkMovementSpeed, 7)
		if pathfindNormal:
			setTarget(Player.current, 80)
		else:
			setTarget(Player.current, 250)
		$ColliderBox/FlipTransform/Animations.play("Idle")
		await enemyReachedTarget
		walkMovementSpeed = 0
		faceTarget()
		mainAnimationPlayer.stop()
		if not pathfindNormal:
			dashNormal = (getTargetPosition() - getPosition()).normalized()
			if dashNormal.x < 0:
				playAnimation("Dash-Left")
			else:
				playAnimation("Dash-Right")
			await TimeManager.wait(0.5)
		
		# dash to the player
		dashing = true
		$ColliderBox/DashParticles.emitting = true
		var rigidBody = $ColliderBox as RigidBody2D
		await TimeManager.promise([hitWithDash, TimeManager.wait(0.75)])
		activateHurtBox($ColliderBox/Hurtbox,  randf_range(12, 18), HurtBoxType.PLAYER)
		$ColliderBox/DashParticles.emitting = false
		faceTarget()
		dashing = false
		
		await TimeManager.wait(0.75)
		
		# start attacking close range
		setTarget(Player.current, 80)
		while withinRangeOfTarget():
			walkMovementSpeed = 0
			faceTarget()
			mainAnimationPlayer.stop()
			playAnimation("Attack")
			await TimeManager.wait(0.15)
			var damage = randf_range(5, 9)
			activateHurtBox($ColliderBox/Hurtbox, damage, HurtBoxType.PLAYER)
			await enemyAnimationFinished
			await TimeManager.wait(0.05)

func physicsProcess(delta: float) -> void:
	if dashing:
		var result: KinematicCollision2D = collisionRigidBody.move_and_collide(dashNormal * 11.5)
		if result:
			hitWithDash.emit()
			$ColliderBox/HitParticles.emitting = true
			if result.get_collider() is not Player:
				# the enemy hit a wall, just pathfind like normal for a few seconds
				# don't try to charge again for a bit
				pathfindNormal = true
				await TimeManager.wait(6.0)
				pathfindNormal = false
