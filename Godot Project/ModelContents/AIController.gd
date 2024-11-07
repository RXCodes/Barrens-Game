class_name EnemyAI extends Node2D

@export_category("Enemy Info")

## The user-facing name of this enemy
@export var enemyName: String = "Dummy"

## The maximum HP that the enemy starts with
@export var maxHealth: int = 100
var currentHealth: float

## The hitbox body of this enemy (what detects attacks)
@export var hitBoxRigidBody: RigidBody2D

## The collision body of this enemy (what interacts with physical bodies)
@export var collisionRigidBody: RigidBody2D
static var enemyAIKey = "EnemyAI"

@export_category("Behaviors")

## Does the enemy do anything?
@export var hasAI: bool = false

## Speed when enemy travels
@export var walkMovementSpeed: float = 1

@export_subgroup("")
@export_subgroup("Gun")

## The enemy attacks by using a gun
@export var gunAttacksEnabled: bool = false

## What gun does the enemy use?
@export var gun: String = "Shotgun"

## Where's the gun that the enemy is holding? (required)
@export var gunSprite: Sprite2D

@export_subgroup("")
@export_category("Animations")

## Animation player for walking, idle and death animations
@export var mainAnimationPlayer: AnimationPlayer

## Animation to play when walking
@export var walkAnimation: String

## Animation to play when idling
@export var idleAnimation: String

## Animation to play when dying
@export var deathAnimation: String

## Animation player for when  or is hit
@export var actionAnimationPlayer: AnimationPlayer

## Animation to play when being hit from the front
@export var hitFrontAnimation: String

## Animation to play when being hit from the back
## -- will reuse front animation if left blank
@export var hitBackAnimation: String

@export_category("Visuals")

## Offset where damage number is displayed
@export var damageIndicatorPositionOffset: Vector2 = Vector2.ZERO

## Offset where health bar is displayed
@export var healthBarPositionOffset: Vector2 = Vector2(0, 20)

# Called when the node enters the scene tree for the first time.
var navigationAgent: NavigationAgent2D
var hitboxShape: Node2D
var hitboxShapeInitialPosition: Vector2
var flipTransform: Node2D
var target: Node2D = Player.current
var healthBar: EnemyHealthBar
func _ready() -> void:
	renderer = get_parent()
	navigationAgent = find_child("NavigationAgent2D")
	flipTransform = find_child("FlipTransform")
	hitboxShape = hitBoxRigidBody.get_children()[0]
	enemies.append(self)
	hitboxShapeInitialPosition = hitboxShape.position
	currentHealth = maxHealth
	if not hitBoxRigidBody:
		hitBoxRigidBody = find_child("Hitbox")
	if hitBoxRigidBody:
		hitBoxRigidBody.set_meta(EnemyAI.enemyAIKey, self)
	if hitBackAnimation.is_empty():
		hitBackAnimation = hitFrontAnimation
	navigationAgent.target_reached.connect(reachedTarget)
	var children = NodeRelations.getChildrenRecursive(self)
	for child: Node in children:
		child.set_meta(EnemyAI.parentControllerKey, self)
	healthBar = preload("res://UI/EnemyHealthBar.tscn").instantiate()
	healthBar.position += healthBarPositionOffset
	hitboxShape.add_child(healthBar)
	await get_tree().physics_frame
	onStart()

# Called every frame. 'delta' is the elapsed time since the previous frame.
var flipX = false
func _process(delta: float) -> void:
	flipTransform.scale.x = -1 if flipX else 1
	if renderer.material is ShaderMaterial:
		renderer.material.set_shader_parameter("normalizedRandom", randf_range(0.6, 1.0))
	runNavigationQueue()
	if not damageInTick.is_empty():
		for nodeRid in damageInTick.keys():
			var damageIndicatorPosition = collisionRigidBody.global_position
			damageIndicatorPosition += damageIndicatorPositionOffset
			damageIndicatorPosition.x += randfn(0, 15)
			damageIndicatorPosition.y += randfn(0, 20)
			var damageValue = damageInTick[nodeRid]
			DamageIndicator.createDamageIndicator(damageIndicatorPosition, damageValue, instance_from_id(nodeRid))
		damageInTick.clear()

static var flashWhiteShader = preload("res://ModelContents/EntityFlashWhite.gdshader")
var renderer: EntityRender

# called when enemy is hit
func onHit(globalPosition: Vector2) -> void:
	if dead:
		return
	var random = Vector2(randfn(0, 10), randfn(0, 10))
	HitParticle.spawnParticle(globalPosition + random, z_index + 30)
	flashWhite(true)
	if actionAnimationPlayer:
		actionAnimationPlayer.stop()
		var directionVector = globalPosition - collisionRigidBody.global_position
		if directionVector.x > 0 == not flipX:
			actionAnimationPlayer.play(hitFrontAnimation)
		else:
			actionAnimationPlayer.play(hitBackAnimation)
	await TimeManager.wait(0.05)
	flashWhite(false)
	pass

# called when enemy is damaged
var damageInTick := {}
func damage(amount: float, source: Node2D) -> void:
	if dead:
		return
	enemyDamaged.emit()
	onDamage()
	if not damageInTick.has(source.get_instance_id()):
		damageInTick[source.get_instance_id()] = 0
	damageInTick[source.get_instance_id()] += amount
	currentHealth -= amount
	if currentHealth <= 0:
		currentHealth = 0
		kill()
	updateHealthBar()

# called when health bar needs to update
func updateHealthBar() -> void:
	healthBar.progress = (currentHealth / maxHealth) * 100.0
	
# called when changing the flashing state of the enemy
func flashWhite(flashing: bool) -> void:
	if flashing:
		renderer.material = ShaderMaterial.new()
		renderer.material.shader = flashWhiteShader
	else:
		renderer.material = null

# called on every physics tick
var shapeTests: Array[ShapeIntersectionTest] = []
func _physics_process(delta: float) -> void:
	hitboxShape.global_position = collisionRigidBody.global_position + hitboxShapeInitialPosition
	if dead:
		return
	if hasAI:
		navigate()
		if shapeTests.size() > 0:
			var directPhysicsState = get_world_2d().direct_space_state
			for shapeTest in shapeTests:
				var intersectedShapes = directPhysicsState.intersect_shape(shapeTest.shapeQueryParameters)
				if intersectedShapes.size() > 0:
					if shapeTest.onSuccess:
						shapeTest.onSuccess.call(intersectedShapes)
			shapeTests.clear()

# pathfinding and movement functionality
var targetDistance: float = 30
func navigate() -> void:
	navigationAgent.target_desired_distance = targetDistance
	if withinRangeOfTarget():
		reachedTarget()
		return
	if mainAnimationPlayer.current_animation != walkAnimation:
		mainAnimationPlayer.stop()
		mainAnimationPlayer.play(walkAnimation)
	var pathfindDirectionVector = collisionRigidBody.global_position.direction_to(navigationAgent.get_next_path_position())
	var movementVector = pathfindDirectionVector * walkMovementSpeed
	faceTarget()
	collisionRigidBody.move_and_collide(movementVector)

# called when enemy reaches its target and is ready to attack
func reachedTarget() -> void:
	if mainAnimationPlayer.current_animation != idleAnimation:
		mainAnimationPlayer.stop()
		mainAnimationPlayer.play(idleAnimation)
	enemyReachedTarget.emit()

# this prevents too many enemies pathfinding at once (laggy)
static var enemies := []
static var enemyQueueIndex = 0
static var maxPathfindLimit = 5
static var readyToRunNavigation = true
static var navigateQueueInterval = 0.05
static func runNavigationQueue() -> void:
	if not readyToRunNavigation:
		return
	readyToRunNavigation = false
	for i in range(maxPathfindLimit):
		enemyQueueIndex += 1
		if enemyQueueIndex >= enemies.size():
			enemyQueueIndex = 0
		var currentAI: EnemyAI = enemies[enemyQueueIndex]
		if currentAI.target:
			currentAI.navigationAgent.target_position = currentAI.target.global_position
	await TimeManager.wait(navigateQueueInterval)
	readyToRunNavigation = true

#                  #
# HELPER FUNCTIONS #
#                  #

# targets a node and starts pathfinding to it
func setTarget(targetNode: Node2D, newTargetDistance: float) -> void:
	target = targetNode
	targetDistance = newTargetDistance
	navigationAgent.target_position = target.global_position

# plays an animation from the Main Animation Player
func playAnimation(animationName: String) -> void:
	if dead:
		return
	actionAnimationPlayer.play(animationName)
	var attackTime = maxf(actionAnimationPlayer.current_animation_length, 0.01)
	await TimeManager.wait(attackTime)
	enemyAnimationFinished.emit()

# makes the enemy face the target
func faceTarget() -> void:
	if dead:
		return
	var directionVector = target.global_position - collisionRigidBody.global_position
	flipX = directionVector.x < 0

# checks if the enemy is within the range of the target
func withinRangeOfTarget() -> bool:
	var distanceSquared = collisionRigidBody.global_position.distance_squared_to(target.global_position)
	return distanceSquared <= targetDistance ** 2

var dead = false
# kills the enemy - setting dead to true
func kill() -> void:
	if dead:
		return
	onDeath()
	dead = true
	hitBoxRigidBody.collision_mask = 0
	hitBoxRigidBody.collision_layer = 0
	collisionRigidBody.collision_mask = 0
	collisionRigidBody.collision_layer = 0
	hasAI = false
	actionAnimationPlayer.stop()
	mainAnimationPlayer.stop()
	mainAnimationPlayer.play(deathAnimation)
	await TimeManager.wait(mainAnimationPlayer.current_animation_length)
	for i in range(3):
		flashWhite(true)
		await TimeManager.wait(0.05)
		flashWhite(false)
		await TimeManager.wait(0.05)
	flashWhite(true)
	await TimeManager.wait(0.05)
	DeathSmokeParticles.spawnParticle(collisionRigidBody.global_position, z_index)
	enemies.erase(self)
	get_parent().queue_free()

enum HurtBoxType {PLAYER, ENEMY, ALL}
static var parentControllerKey = "ParentControllerKey"
# checks if a shape intersects with other players and enemies, dealing damage
func activateHurtBox(shape: CollisionShape2D, damage: float, type: HurtBoxType) -> void:
	var newIntersectionTest = ShapeIntersectionTest.new()
	newIntersectionTest.setDetectionType(type)
	newIntersectionTest.setCollisionShape(shape)
	newIntersectionTest.exclude(collisionRigidBody)
	newIntersectionTest.onSuccess = func(shapes):
		for dictionary: Dictionary in shapes:
			var collider = dictionary.collider
			var parent = collider.get_meta(parentControllerKey)
			if parent:
				parent.damage(damage, collisionRigidBody)
	shapeTests.append(newIntersectionTest)
	
	# let's also make it flash so we can see it being activated in debug
	var originalDebugColor = shape.debug_color
	shape.debug_color = Color(1, 1, 1, 0.9)
	await TimeManager.wait(0.05)
	shape.debug_color = originalDebugColor

#                                  #
# FUNCTIONS THAT CAN BE OVERRIDDEN #
#                                  #

# define what the enemy does on start
func onStart() -> void:
	pass

# define what happens when the enemy dies
func onDeath() -> void:
	pass

# define what happened when the enemy is damaged
func onDamage() -> void:
	pass

#                     #
# SIGNALS             #
#                     #
# Usage: await <name> #

# when the enemy has reached the range of its target
signal enemyReachedTarget

# when the enemy finishes an animation
signal enemyAnimationFinished

# when the enemy was damaged
signal enemyDamaged

#            #
# STRUCTURES #
#            #

class ShapeIntersectionTest:
	var shapeQueryParameters: PhysicsShapeQueryParameters2D
	var onSuccess: Callable
	
	func _init() -> void:
		shapeQueryParameters = PhysicsShapeQueryParameters2D.new()
		shapeQueryParameters.collide_with_bodies = true
		shapeQueryParameters.collide_with_areas = false
		setDetectionType(HurtBoxType.PLAYER)
	
	func exclude(collider: CollisionObject2D) -> void:
		var exclude = shapeQueryParameters.exclude
		exclude.append(collider.get_rid())
		shapeQueryParameters.exclude = exclude
	
	func setCollisionShape(newCollisionShape: CollisionShape2D) -> void:
		shapeQueryParameters.shape = newCollisionShape.shape
		shapeQueryParameters.transform = newCollisionShape.global_transform
	
	func setDetectionType(hurtboxType: HurtBoxType) -> void:
		if hurtboxType == HurtBoxType.PLAYER:
			shapeQueryParameters.collision_mask = 2**(1-1) # collision mask 0
		elif hurtboxType == HurtBoxType.ENEMY:
			shapeQueryParameters.collision_mask = 2**(3-1) # collision mask 3
		elif hurtboxType == HurtBoxType.ALL:
			shapeQueryParameters.collision_mask = (2**(1-1)) + (2**(3-1)) # collision masks 0 and 3
