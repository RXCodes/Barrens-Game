extends EnemyAI
class_name SnakeEnemy

var player: Node2D
var is_player_in_range: bool = false

# Function called when the enemy spawns into the scene
func onStart() -> void:
	var wave = VillageController.currentWave
	if Player.current != null:
		setTarget(Player.current, 80)
		# Loop this while the enemy is alive
		while not dead:
			$ColliderBox/FlipTransform/Animations.play("Idle")
			walkMovementSpeed = 3  # Snake moves at a slow speed by default
			walkMovementSpeed = 3 * (1 + (wave - 8) * 0.05)
			walkMovementSpeed = min(walkMovementSpeed, 8)
			await enemyReachedTarget
			# Make the enemy attack while in range of the player
			while withinRangeOfTarget():
				# Face towards the player
				faceTarget()
				walkMovementSpeed = 0  # Increase speed when attacking
				# Play an attack animation
				$ColliderBox/AttackSound.play()
				$ColliderBox/FlipTransform/Animations.play("Attack")
				await TimeManager.wait(.3)
				# Use the hurtbox to deal damage to the player
				var damage = randf_range(14, 22) # random float from 6 to 12
				activateHurtBox($ColliderBox/Hurtbox, damage, HurtBoxType.PLAYER)
				# Little delay before enemy attacks again
				await TimeManager.wait(1.2)
