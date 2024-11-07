class_name EnemySpawner

static func spawnEnemy(name: String, position: Vector2) -> Node2D:
	var newEnemy: PackedScene = load("res://Models/" + name + ".tscn")
	var newEnemyInstance = newEnemy.instantiate()
	newEnemyInstance.get_children()[0].position = position
	NodeRelations.rootNode.find_child("Level").add_child(newEnemyInstance)
	return newEnemyInstance

static var smallCashDrop = preload("res://Models/SmallCash.tscn")
static var mediumCashDrop = preload("res://Models/MediumCash.tscn")
static var largeCashDrop = preload("res://Models/LargeCash.tscn")
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
