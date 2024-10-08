class_name EnemySpawner

static func spawnEnemy(name: String, position: Vector2) -> void:
	var newEnemy: PackedScene = load("res://Models/" + name + ".tscn")
	var newEnemyInstance = newEnemy.instantiate()
	newEnemyInstance.get_children()[0].position = position
	NodeRelations.rootNode.find_child("Level").add_child(newEnemyInstance)
