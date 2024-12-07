class_name EnemySpawner

# spawns a model from the res://Models/ folder
static func spawnEnemy(name: String, position: Vector2) -> Node2D:
	var newEnemy: PackedScene = load("res://Models/" + name + ".tscn")
	var newEnemyInstance = newEnemy.instantiate()
	newEnemyInstance.position = position
	NodeRelations.rootNode.find_child("Level").add_child(newEnemyInstance)
	return newEnemyInstance

# batch instantiates models from the res://Models/ folder in another thread
# free the thread after finishing using it
static func batchInstantiateEnemies(enemyNames: Array) -> BatchInstantiateEnemyResult:
	var result = BatchInstantiateEnemyResult.new()
	result.total = enemyNames.size()
	var thread = Thread.new()
	var error: Error = thread.start(func():
		print("- Creating enemies on another thread -")
		for name: String in enemyNames:
			var newEnemy: PackedScene = ResourceLoader.load("res://Models/" + name + ".tscn")
			var newEnemyInstance = newEnemy.instantiate()
			result.nodes.append(newEnemyInstance)
			result.progress = float(result.nodes.size()) / result.total
		thread.wait_to_finish()
		result.success = true
		result.completed.emit()
		print("- Completed instantiating enemies -")
	)
	if error:
		print("Failed to create thread to instantiate enemies")
		result.completed.emit()
	return result

# used in batchInstantiateEnemies function
class BatchInstantiateEnemyResult:
	signal completed
	var nodes: Array = []
	var total: int
	var progress: float
	var success: bool = false

static var smallCashDrop = preload("res://Models/SmallCash.tscn")
static var mediumCashDrop = preload("res://Models/MediumCash.tscn")
static var largeCashDrop = preload("res://Models/LargeCash.tscn")
static var massiveCashDrop = preload("res://Models/MassiveCash.tscn")

# spawns cash in the scene
static func spawnMoney(amount: int, position: Vector2) -> void:
	var cashDrops = [smallCashDrop, mediumCashDrop, largeCashDrop, massiveCashDrop]
	while amount > 0:
		var potentialCashDrops = [0]
		var potentialCashValues = [randi_range(1, mini(9, amount))]
		if amount >= 10:
			potentialCashDrops.append(1)
			potentialCashValues.append(randi_range(10, mini(49, amount)))
		if amount >= 50:
			potentialCashDrops.append(2)
			potentialCashValues.append(randi_range(50, mini(200, amount)))
		if amount >= 250:
			potentialCashDrops.append(3)
			potentialCashValues.append(randi_range(250, mini(500, amount)))
		var index = potentialCashDrops.pick_random()
		var newCashDrop = cashDrops[index].instantiate()
		newCashDrop.global_position = position
		NodeRelations.rootNode.find_child("Level").add_child(newCashDrop)
		newCashDrop.amount = potentialCashValues[index]
		amount -= potentialCashValues[index]
		await TimeManager.wait(0.025)

# spawns a weapon item into the scene
static var gunPickup = preload("res://Models/WeaponPickup.tscn")
static func spawnWeapon(gun: Gun, position: Vector2) -> void:
	var newWeaponEntity: WeaponEntity = gunPickup.instantiate()
	newWeaponEntity.setupWithGun(gun)
	newWeaponEntity.global_position = position
	NodeRelations.rootNode.find_child("Level").add_child(newWeaponEntity)
