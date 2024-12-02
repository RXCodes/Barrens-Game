class_name Item extends Node2D

var entity: Item.Entity
var canBePickedUp = true
var pickingUp = false
var pickupDuration = 0.25
static var itemData = {}

static func _static_init() -> void:
	print("------- Setting up items -------")
	var filePaths = DirAccess.get_files_at("res://Items/")
	for filePath in filePaths:
		if filePath.ends_with(".gd"):
			var itemPath = "res://Items/" + filePath
			var currentScript: Script = load(itemPath)
			if currentScript.has_method("setup"):
				currentScript.setup()
				print("Setup item: " + itemPath)
	print("------- End setup items -------")

static func spawnItem(identifier: String, amount: int, position: Vector2) -> void:
	var newItem: Item = preload("res://Items/Item.tscn").instantiate()
	newItem.setupWithItemEntity(itemData[identifier])

static func registerItem(identifier: String, entity: Item.Entity) -> void:
	print("Registered item with identifier: " + identifier)
	itemData[identifier] = entity

func setupWithItemEntity(newEntity: Item.Entity) -> void:
	entity = newEntity
	$Item.texture = entity.itemTexture
	$Item.offset = entity.itemOffset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y -= 35
	$Item.scale = Vector2.ZERO
	$Shadow.scale = Vector2.ZERO
	$AnimationPlayer.speed_scale = randfn(1.0, 0.15)
	$AnimationPlayer.play("Spawn")
	var moveTween = NodeRelations.createTween()
	moveTween.set_ease(Tween.EASE_OUT)
	moveTween.set_trans(Tween.TRANS_CUBIC)
	var newPosition = global_position
	newPosition.x += randfn(0, 30)
	newPosition.y += randfn(0, 12.5)
	var tweenDuration = 1.0 / $AnimationPlayer.speed_scale
	moveTween.tween_property(self, "global_position", newPosition, tweenDuration)
	await TimeManager.wait(1.25)
	canBePickedUp = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Player.current.dead:
		return
	if pickingUp:
		pickupAnimationProgress += delta / pickupDuration
		var targetPosition = Player.current.global_position + Vector2(0, -35)
		var newPosition = originalPosition.lerp(targetPosition, pickupAnimationProgress)
		global_position = newPosition
		$Item.rotation_degrees += (global_position.x - Player.current.global_position.x) * delta
		z_index = 4096
		if pickupAnimationProgress >= 1.0:
			Player.current
			queue_free()

var pickupAnimationProgress = 0.0
var originalPosition: Vector2
func pickup() -> void:
	if not canBePickedUp:
		return
	canBePickedUp = false
	pickingUp = true
	originalPosition = global_position
	$AnimationPlayer.play("Pickup")

# override this method to define what happens when the user consumes this item
# if left blank, the item will not be a consumable
func onConsume() -> void:
	pass

class Entity extends Node:
	var identifier: String
	var displayName: String
	var description: String
	var itemTexture: Texture2D
	var itemOffset: Vector2
	var amount: int
	var onConsume: Callable
