extends EnemyAI
class_name ScorpionEnemy

var player: Node2D
var is_player_in_range: bool = false

# Function called when the enemy spawns into the scene
func onStart() -> void:
	if Player.current != null:
		setTarget(Player.current, 70)
		# Loop this while the enemy is alive
		while not dead:
			$ColliderBox/FlipTransform/Animations.play("Idle")
			walkMovementSpeed = 2
			await enemyReachedTarget
			# Make the enemy attack while in range of the player
			while withinRangeOfTarget():
				# Face towards the player
				faceTarget()
				walkMovementSpeed = 4
				# Play an attack animation
				$ColliderBox/FlipTransform/Animations.play("Attack")
				# Use the hurtbox to deal damage to the player
				var damage = randf_range(8, 14) # random float from 8 to 14
				activateHurtBox($ColliderBox/Hurtbox, damage, HurtBoxType.PLAYER)
				# Little delay before enemy attacks again
				await TimeManager.wait(1.5)