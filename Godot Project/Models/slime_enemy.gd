extends EnemyAI
class_name BaseSlimeEnemy

var player: Node2D
var is_player_in_range: bool = false

# Function called when the enemy spawns into the scene
func onStart() -> void:
	if Player.current != null:
		setTarget(Player.current, 30)
		# Loop this while the enemy is alive
		while not dead:
			$ColliderBox/FlipTransform/Animations.play("Idle")
			walkMovementSpeed = 2  # Slow speed when approaching the player
			await enemyReachedTarget
			# Make the enemy attack while in range of the player
			while withinRangeOfTarget():
				# Face towards the player
				faceTarget()
				walkMovementSpeed = 2  # Medium speed when attacking
				# Play an attack animation
				$ColliderBox/FlipTransform/Animations.play("Attack")
				# Use the hurtbox to deal damage to the player
				var damage = randf_range(2, 4)  # Random float from 6 to 10
				activateHurtBox($ColliderBox/Hurtbox, damage, HurtBoxType.PLAYER)
				# Little delay before base slime attacks again
				await TimeManager.wait(1.5)
