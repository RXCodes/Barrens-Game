class_name ExampleEnemy extends EnemyAI

# the enemy has spawned into the scene
func onStart():
	
	# let's have the enemy pathfind to the player 
	# you can set the target to be any node in the scene
	# enemy will stop when within 60 world units of the target
	setTarget(Player.current, 60)
	
	# loop this while the enemy is alive
	while not dead:
	
		# wait until the enemy is within range of the player
		await enemyReachedTarget
		
		# make the enemy attack while in range of the player
		while withinRangeOfTarget():
			
			# face towards the player
			faceTarget()
			
			# play an attack animation
			attack("Punch")
			
			# use the hurtbox to deal damage to the player
			var damage = randf_range(3, 6) # random float from 3 to 6
			activateHurtBox($ColliderBox/Hurtbox, damage, HurtBoxType.PLAYER)
			
			# wait for the enemy's attack animation to finish before attacking again
			await enemyAttackFinished or enemyDamaged
			
			# little delay before enemy attacks again
			await TimeManager.wait(0.1)
		
		# a little delay before the loop restarts
		await TimeManager.wait(0.6)
