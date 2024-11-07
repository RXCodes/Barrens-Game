class_name EnemySpawner

static func spawnEnemy(name: String, position: Vector2) -> Node2D:
	var newEnemy: PackedScene = load("res://Models/" + name + ".tscn")
	var newEnemyInstance = newEnemy.instantiate()
	newEnemyInstance.get_children()[0].position = position
	NodeRelations.rootNode.find_child("Level").add_child(newEnemyInstance)
	return newEnemyInstance

static func spawnMoney(amount: int, position: Vector2) -> void:
	for i in range(amount):
		var newCashDrop = preload("res://Models/SmallCash.tscn").instantiate()
		newCashDrop.global_position = position
		NodeRelations.rootNode.find_child("Level").add_child(newCashDrop)
		newCashDrop.amount = 1
		await TimeManager.wait(0.025)
