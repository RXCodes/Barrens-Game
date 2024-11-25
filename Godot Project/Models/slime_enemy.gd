extends EnemyAI
class_name BaseSlimeEnemy

# States for the slime
enum State {
	IDLE,
	MOVING,
	ATTACKING,
	DEAD
}

var current_state: State = State.IDLE
var player: Node2D
var is_player_in_range: bool = false

# Timer for attack cooldown
var attack_cooldown: float = 1.0
var last_attack_time: float = -1.0

# Function called when the enemy spawns into the scene
func onStart() -> void:
	if Player.current != null:
		setTarget(Player.current, 60)
		# Loop this while the enemy is alive
		while not dead:
			# Wait until the enemy is within range of the player
			await enemyReachedTarget
			# Make the enemy attack while in range of the player
			while withinRangeOfTarget():
				# Face towards the player
				faceTarget()
				# Play an attack animation
				playAnimation("Punch")
				# Use the hurtbox to deal damage to the player
				var damage = randf_range(3, 6) # random float from 3 to 6
				activateHurtBox($ColliderBox/Hurtbox, damage, HurtBoxType.PLAYER)
				# Wait for the enemy's attack animation to finish before attacking again
				await enemyAnimationFinished
				# Little delay before enemy attacks again
				await TimeManager.wait(0.1)
			# A little delay before the loop restarts
			await TimeManager.wait(0.6)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state == State.DEAD:
		return  # Skip the rest if the slime is dead

	if Player.current != null and collisionRigidBody != null:
		is_player_in_range = (Player.current.global_position - collisionRigidBody.global_position).length() <= 60

	if current_state == State.IDLE:
		if is_player_in_range:
			current_state = State.MOVING  # Move towards the player if in range

	elif current_state == State.MOVING:
		if is_player_in_range:
			move_towards_player(delta)
		else:
			current_state = State.IDLE  # If player is out of range, go back to idle

	elif current_state == State.ATTACKING:
		# If we're attacking, check if we can attack again
		if (get_tree().get_ticks_msec() - last_attack_time) >= attack_cooldown * 1000:
			last_attack_time = get_tree().get_ticks_msec()
			attack_player()

# Function to move towards the player
func move_towards_player(delta: float) -> void:
	if Player.current != null and collisionRigidBody != null:
		var direction = (Player.current.global_position - collisionRigidBody.global_position).normalized()
		collisionRigidBody.move_and_collide(direction * walkMovementSpeed * delta)

		# If close enough to attack, switch to attack state
		if (Player.current.global_position - collisionRigidBody.global_position).length() <= 10:
			current_state = State.ATTACKING

# Function for attacking the player
func attack_player() -> void:
	# Example: Deal damage to the player (assuming player has a take_damage function)
	if Player.current != null:
		Player.current.take_damage(10)  # Adjust damage value as needed
	current_state = State.IDLE  # Switch back to idle after attack

# Function to handle taking damage
func take_damage(amount: int) -> void:
	currentHealth -= amount
	if currentHealth <= 0:
		currentHealth = 0
		kill()

# Handle death and drop cash
func kill() -> void:
	current_state = State.DEAD
	queue_free()  # Remove the slime from the scene

# Update Health Bar
func updateHealthBar() -> void:
	if healthBar != null:
		healthBar.progress = (currentHealth / maxHealth) * 100.0

# Handle death animations and state changes
func onDeath() -> void:
	# Death animation and removal logic here
	pass

# Called when enemy is damaged
func onDamage() -> void:
	# Play damage animations and sounds
	if actionAnimationPlayer != null:
		actionAnimationPlayer.play(hitFrontAnimation)
	pass

# Pathfinding and movement functionality
func navigate() -> void:
	navigationAgent.target_desired_distance = targetDistance
	if withinRangeOfTarget():
		reachedTarget()
		return

	if mainAnimationPlayer != null:
		if mainAnimationPlayer.current_animation != walkAnimation:
			mainAnimationPlayer.stop()
			mainAnimationPlayer.play(walkAnimation)

	var pathfindDirectionVector = collisionRigidBody.global_position.direction_to(navigationAgent.get_next_path_position())
	var movementVector = pathfindDirectionVector * walkMovementSpeed
	faceTarget()
	collisionRigidBody.move_and_collide(movementVector)

# Called when enemy reaches its target and is ready to attack
func reachedTarget() -> void:
	if mainAnimationPlayer != null and mainAnimationPlayer.current_animation != idleAnimation:
		mainAnimationPlayer.stop()
		mainAnimationPlayer.play(idleAnimation)
	enemyReachedTarget.emit()
