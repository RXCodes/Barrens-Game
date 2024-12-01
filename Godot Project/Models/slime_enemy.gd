extends EnemyAI
class_name BaseSlimeEnemy

var player: Node2D
var is_player_in_range: bool = false

# Function called when the enemy spawns into the scene
func onStart() -> void:
	setTarget(Player.current, 100)
	while not dead:
		walkMovementSpeed = 2  # Slow speed when approaching the player
		await enemyReachedTarget
		# Make the enemy attack while in range of the player
		while withinRangeOfTarget():
			faceTarget()
			walkMovementSpeed = 0  
			mainAnimationPlayer.stop()
			playAnimation("Attack")
			await TimeManager.wait(.7)
			activateHurtBox($ColliderBox/Hurtbox,  randf_range(3, 5), HurtBoxType.PLAYER)
			await enemyAnimationFinished
			await TimeManager.wait(0.02)
		await TimeManager.wait(0.02)
