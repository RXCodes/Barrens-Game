class_name EnemyAI extends Node2D

@export_category("Enemy Info")

## The user-facing name of this enemy
@export var enemyName: String = "Dummy"

## The maximum HP that the enemy starts with
@export var maxHealth: int = 100
var currentHealth = maxHealth

## The rigid body of this enemy
@export var rigidBody: RigidBody2D
static var enemyAIKey = "EnemyAI"

@export_category("Behaviors")

## Does the enemy do anything?
@export var hasAI: bool = false

## Speed when enemy walks
@export var walkMovementSpeed: float = 5

## How close does the enemy need to be to the player to attack?
@export var attackRange: float = 1000

## How long does it take for the enemy to attack again in seconds?
@export var attackTime: float = 0.5

@export_category("Animations")

## Animation player for walking, idle and death animations
@export var mainAnimationPlayer: AnimationPlayer

## Animation to play when walking
@export var walkAnimation: Animation

## Animation to play when idling
@export var idleAnimation: Animation

## Animation to play when dying
@export var deathAnimation: Animation

## Animation player for when the enemy attacks or is hit
@export var actionAnimationPlayer: AnimationPlayer

## Animation to play when attacking
@export var attackAnimation: Animation

## Animation to play when being hit
@export var hitAnimation: Animation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not rigidBody:
		rigidBody = find_child("Rigidbody")
	if rigidBody:
		rigidBody.set_meta(EnemyAI.enemyAIKey, self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
var flipX = false
func _process(delta: float) -> void:
	rigidBody.scale.x = -1 if flipX else 1

func onHit(globalPosition: Vector2) -> void:
	var random = Vector2(randfn(0, 15), randfn(0, 15))
	HitParticle.spawnParticle(globalPosition + random, z_index + 30)

func damage(amount: float) -> void:
	currentHealth -= amount
	if currentHealth <= 0:
		get_parent().queue_free()
