extends EnemyAI
class_name AcidSlimeEnemy

var player: Node2D
var is_player_in_range: bool = false

# Function called when the enemy spawns into the scene
func onStart() -> void:
	if Player.current != null:
		setTarget(Player.current, 40)
		# Loop this while the enemy is alive
		while not dead:
			$ColliderBox/FlipTransform/Animations.play("Idle")
			walkMovementSpeed = 2  # Medium speed when approaching the player
			await enemyReachedTarget
			# Make the enemy attack while in range of the player
			while withinRangeOfTarget():
				# Face towards the player
				faceTarget()
				walkMovementSpeed = 3  # Fast speed when attacking
				# Play an attack animation
				$ColliderBox/FlipTransform/Animations.play("Attack")
				# Use the hurtbox to deal damage to the player
				var damage = randf_range(4, 6)  # Random float from 10 to 16
				activateHurtBox($ColliderBox/Hurtbox, damage, HurtBoxType.PLAYER)
				# Little delay before acid slime attacks again
				await TimeManager.wait(1.3)
