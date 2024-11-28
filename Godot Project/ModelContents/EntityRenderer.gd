extends CanvasGroup
class_name EntityRender
var targetNode: Node

# this is what will be used to render the player, all enemies and npcs
## how much to offset the z index
@export var entityZIndexOffset = 0

## should the enemy face left?
@export var flipX = false

var colliderBoxNode: RigidBody2D
var initialPosition: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targetNode = get_children()[0]
	if targetNode is EnemyAI:
		targetNode.flipX = flipX
		colliderBoxNode = targetNode.collisionRigidBody
	if colliderBoxNode:
		initialPosition = colliderBoxNode.position

func _process(delta: float) -> void:
	if colliderBoxNode:
		var offset = colliderBoxNode.position - initialPosition
		global_position += offset
		colliderBoxNode.position = initialPosition
