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

## Speed when enemy walks
@export var walkMovementSpeed: float = 1

## How close does the enemy need to be to the player to attack?
@export var attackRange: float = 1000

## How long does it take for the enemy to attack again in seconds?
@export var attackTime: float = 0.5

@export_category("Animations")

## Animation player for walking, idle and death animations
@export var mainAnimationPlayer: AnimationPlayer

## Animation to play when walking
@export var walkAnimation: String

## Animation to play when idling
@export var idleAnimation: String

## Animation to play when dying
@export var deathAnimation: String

## Animation player for when the enemy attacks or is hit
@export var actionAnimationPlayer: AnimationPlayer

## Animation to play when attacking
@export var attackAnimation: String

## Animation to play when being hit from the front
@export var hitFrontAnimation: String

## Animation to play when being hit from the back
## -- will reuse front animation if left blank
@export var hitBackAnimation: String

# Called when the node enters the scene tree for the first time.
var navigationAgent: NavigationAgent2D
var hitboxShape: Node2D
var hitboxShapeInitialPosition: Vector2
var flipTransform: Node2D
func _ready() -> void:
	renderer = get_parent()
	navigationAgent = find_child("NavigationAgent2D")
	flipTransform = find_child("FlipTransform")
	hitboxShape = hitBoxRigidBody.get_children()[0]
	navigationAgents.append(navigationAgent)
	hitboxShapeInitialPosition = hitboxShape.position
	currentHealth = maxHealth
	if not hitBoxRigidBody:
		hitBoxRigidBody = find_child("Hitbox")
	if hitBoxRigidBody:
		hitBoxRigidBody.set_meta(EnemyAI.enemyAIKey, self)
	if hitBackAnimation.is_empty():
		hitBackAnimation = hitFrontAnimation

# Called every frame. 'delta' is the elapsed time since the previous frame.
var flipX = false
func _process(delta: float) -> void:
	flipTransform.scale.x = -1 if flipX else 1
	if renderer.material is ShaderMaterial:
		renderer.material.set_shader_parameter("normalizedRandom", randf_range(0.6, 1.0))
	runNavigationQueue()

static var flashWhiteShader = preload("res://ModelContents/EntityFlashWhite.gdshader")
var renderer: EntityRender

func onHit(globalPosition: Vector2) -> void:
	if dead:
		return
	var random = Vector2(randfn(0, 15), randfn(0, 15))
	HitParticle.spawnParticle(globalPosition + random, z_index + 30)
	flashWhite(true)
	if actionAnimationPlayer:
		actionAnimationPlayer.stop()
		var directionVector = globalPosition - global_position
		if directionVector.x > 0 == not flipX:
			actionAnimationPlayer.play(hitFrontAnimation)
		else:
			actionAnimationPlayer.play(hitBackAnimation)
	await TimeManager.wait(0.05)
	flashWhite(false)

func damage(amount: float) -> void:
	if dead:
		return
	currentHealth -= amount
	if currentHealth <= 0:
		currentHealth = 0
		kill()

func flashWhite(flashing: bool) -> void:
	if flashing:
		renderer.material = ShaderMaterial.new()
		renderer.material.shader = flashWhiteShader
	else:
		renderer.material = null

var dead = false
func kill() -> void:
	if dead:
		return
	dead = true
	hitBoxRigidBody.collision_mask = 0
	hitBoxRigidBody.collision_layer = 0
	collisionRigidBody.collision_mask = 0
	collisionRigidBody.collision_layer = 0
	hasAI = false
	if actionAnimationPlayer:
		actionAnimationPlayer.stop()
	if mainAnimationPlayer:
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
	navigationAgents.erase(navigationAgent)
	get_parent().queue_free()

func _physics_process(delta: float) -> void:
	hitboxShape.global_position = collisionRigidBody.global_position + hitboxShapeInitialPosition
	if not hasAI or dead:
		return
	if navigationAgent.is_navigation_finished():
		return
	var pathfindDirectionVector = collisionRigidBody.global_position.direction_to(navigationAgent.get_next_path_position())
	var movementVector = pathfindDirectionVector * walkMovementSpeed
	flipX = movementVector.x <= 0
	collisionRigidBody.move_and_collide(movementVector)

# this prevents too many enemies pathfinding at once (laggy)
static var navigationAgents := []
static var navigationQueueIndex = 0
static var maxPathfindLimit = 10
static var readyToRunNavigation = true
static var navigateQueueInterval = 0.025
static func runNavigationQueue() -> void:
	if not readyToRunNavigation:
		return
	readyToRunNavigation = false
	for i in range(maxPathfindLimit):
		navigationQueueIndex += 1
		if navigationQueueIndex >= navigationAgents.size():
			navigationQueueIndex = 0
		var currentNavigationAgent: NavigationAgent2D = navigationAgents[navigationQueueIndex]
		currentNavigationAgent.target_position = Player.current.global_position
	await TimeManager.wait(navigateQueueInterval)
	readyToRunNavigation = true
