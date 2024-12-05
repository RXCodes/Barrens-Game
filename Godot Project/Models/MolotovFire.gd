class_name MolotovFire extends Node2D

var isFromPlayer = false
var damagePerSecond: float = 1
var hurtBoxType: EnemyAI.HurtBoxType

static func create(position: Vector2, damage: float, hurtBoxType: EnemyAI.HurtBoxType) -> MolotovFire:
	var molotov: MolotovFire = preload("res://Models/MolotovFire.tscn").instantiate()
	molotov.global_position = position
	NodeRelations.rootNode.find_child("Level").add_child(molotov)
	molotov.damagePerSecond = damage
	molotov.hurtBoxType = hurtBoxType
	return molotov

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Fire.emitting = true
	var flash = $Flash
	var tween = NodeRelations.createTween()
	tween.tween_property(flash, "modulate", Color.TRANSPARENT, 0.25)
	$Blast.emitting = true
	await get_tree().physics_frame
	for i in range(12):
		activateHurtBox(damagePerSecond, hurtBoxType)
		activateHurtBox(5, EnemyAI.HurtBoxType.PLAYER)
		if i == 10:
			$Fire.emitting = false
			var fadeOut = NodeRelations.createTween()
			fadeOut.tween_property($Light, "modulate", Color.TRANSPARENT, 2.5)
		await TimeManager.wait(1.0)
	
	# wait lots of time before freeing - other enemies will use this when they are burning
	await TimeManager.wait(12.0)
	queue_free()

var damageFalloff = 0.5
func activateHurtBox(damage: float, type: EnemyAI.HurtBoxType) -> void:
	var newIntersectionTest = EnemyAI.ShapeIntersectionTest.new()
	newIntersectionTest.setDetectionType(type)
	newIntersectionTest.setCollisionShape($StaticBody2D/Hurtbox)
	newIntersectionTest.onSuccess = func(shapes):
		for dictionary: Dictionary in shapes:
			var collider = dictionary.collider
			var distance = collider.global_position.distance_to(global_position)
			var parent = collider.get_meta(EnemyAI.parentControllerKey)
			if parent:
				var newDamage = lerpf(damage * damageFalloff, damage, distance / 260)
				if type == EnemyAI.HurtBoxType.ALL:
					parent.damage(newDamage, self)
					parent.burningTime = 10
				elif parent is EnemyAI and type == EnemyAI.HurtBoxType.ENEMY:
					parent.damage(newDamage, self)
					parent.burningTime = 10
				elif parent is Player and type == EnemyAI.HurtBoxType.PLAYER:
					parent.damage(newDamage, self)
					parent.burningTime = 10
	shapeTests.append(newIntersectionTest)

var shapeTests: Array[EnemyAI.ShapeIntersectionTest] = []
func _physics_process(delta: float) -> void:
	if shapeTests.size() > 0:
		var directPhysicsState = get_world_2d().direct_space_state
		for shapeTest in shapeTests:
			var intersectedShapes = directPhysicsState.intersect_shape(shapeTest.shapeQueryParameters, 100)
			if intersectedShapes.size() > 0:
				if shapeTest.onSuccess:
					shapeTest.onSuccess.call(intersectedShapes)
		shapeTests.clear()
