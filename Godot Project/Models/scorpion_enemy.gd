extends EnemyAI
class_name ScorpionEnemy

var canDash = false
var dashing = false
var dashNormal: Vector2
signal dashComplete

# Function called when the enemy spawns into the scene
func onStart() -> void:
	dashLoop()
	
	# Loop this while the enemy is alive
	while not dead:
		
		# slowly travel towards the player
		$ColliderBox/FlipTransform/Animations.play("Idle")
		walkMovementSpeed = 1.5
		await enemyReachedTarget
		
		# dash towards the player if needed
		walkMovementSpeed = 0
		if canDash:
			var targetPosition = Player.current.position
			defaultMaterial = ShaderMaterial.new()
			defaultMaterial.shader = preload("res://ModelContents/EntityGlow.gdshader")
			playAnimation("Glow")
			await TimeManager.wait(0.7)
			defaultMaterial = null
			dashTowardsPosition(targetPosition)
			await dashComplete
			activateHurtBox($ColliderBox/Hurtbox, randf_range(25, 35), HurtBoxType.PLAYER)
			$ColliderBox/FlipTransform/Animations.stop()
			await TimeManager.wait(0.5)
		
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
		await TimeManager.wait(randf_range(4.0, 8.0))
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
		var result: KinematicCollision2D = collisionRigidBody.move_and_collide(dashNormal * 12.5)
		if result:
			$ColliderBox/Shape.scale = Vector2(1, 1)
			dashComplete.emit()
			dashing = false
