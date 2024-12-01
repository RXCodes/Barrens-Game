class_name EnemySpawner

# spawns a model from the res://Models/ folder
static func spawnEnemy(name: String, position: Vector2) -> Node2D:
	var newEnemy: PackedScene = load("res://Models/" + name + ".tscn")
	var newEnemyInstance = newEnemy.instantiate()
	newEnemyInstance.position = position
	NodeRelations.rootNode.find_child("Level").add_child(newEnemyInstance)
	return newEnemyInstance

# batch instantiates models from the res://Models/ folder in another thread
static func batchInstantiateEnemies(enemyNames: Array) -> BatchInstantiateEnemyResult:
	var result = BatchInstantiateEnemyResult.new()
	result.total = enemyNames.size()
	var thread = Thread.new()
	thread.start(func():
		for name: String in enemyNames:
			var newEnemy: PackedScene = load("res://Models/" + name + ".tscn")
			var newEnemyInstance = newEnemy.instantiate()
			result.nodes.append(newEnemyInstance)
			result.progress = float(result.nodes.size()) / result.total
		result.completed.emit()
	)
	return result

# used in batchInstantiateEnemies function
class BatchInstantiateEnemyResult:
	signal completed
	var nodes: Array = []
	var total: int
	var progress: float

static var smallCashDrop = preload("res://Models/SmallCash.tscn")
static var mediumCashDrop = preload("res://Models/MediumCash.tscn")
static var largeCashDrop = preload("res://Models/LargeCash.tscn")

# spawns cash in the scene
static func spawnMoney(amount: int, position: Vector2) -> void:
	var cashDrops = [smallCashDrop, mediumCashDrop, largeCashDrop]
	while amount > 0:
		var potentialCashDrops = [0]
		var potentialCashValues = [randi_range(1, mini(9, amount))]
		if amount >= 10:
			potentialCashDrops.append(1)
			potentialCashValues.append(randi_range(10, mini(49, amount)))
		if amount >= 50:
			potentialCashDrops.append(2)
			potentialCashValues.append(randi_range(10, mini(200, amount)))
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
