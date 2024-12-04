extends EnemyAI
class_name WormEnemy

var player: Node2D
var is_player_in_range: bool = false

# Function called when the enemy spawns into the scene
func onStart() -> void:
	var wave = VillageController.currentWave
	if Player.current != null:
		setTarget(Player.current, 600)
		# Loop this while the enemy is alive
		while not dead:
			$ColliderBox/FlipTransform/Animations.play("Idle")
			walkMovementSpeed = 1  # Worm moves slowly when approaching the player
			walkMovementSpeed = (1 + (wave - 11) * 0.05)
			walkMovementSpeed = min(walkMovementSpeed, 2.5)
			await enemyReachedTarget
			# Make the enemy attack while in range of the player
			while withinRangeOfTarget():
				# Face towards the player
				faceTarget()
				walkMovementSpeed = 0  # Worm doesn't move while attacking
				# Play attack animation
				playAnimation("Attack")
				await enemyAnimationFinished
				await TimeManager.wait(0.05)
				$ColliderBox/FlipTransform/Animations.play("Idle")
				
				# delay before worm attacks again
				var cooldown = max(4.0 - (wave - 11) * 0.15, 2.0)
				await TimeManager.wait(4.0)

func summonProjectile() -> void:
	pass
