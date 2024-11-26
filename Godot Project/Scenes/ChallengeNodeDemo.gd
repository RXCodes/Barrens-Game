extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
var activated = false
var monsterCount = 0
var maxMonsterCount = 30
func _process(delta: float) -> void:
	if not activated:
		if Player.current.global_position.distance_squared_to(global_position) > 350:
			return
		Player.current.pickupAmmo()
		Player.current.refreshAmmoDisplay()
		$"../Challenge Text".text = "Lol have fun"
		activated = true
	else:
		monsterCount = get_tree().get_nodes_in_group("Monster").size()
		if monsterCount < maxMonsterCount:
			var spawnPosition = Vector2(randfn(0, 1000), randfn(0, 1000))
			var playerPosition = Player.current.global_position
			if spawnPosition.distance_squared_to(playerPosition) <= 300:
				return
			var renderer: EntityRender = EnemySpawner.spawnEnemy("Dummy", spawnPosition)
			var entity: EnemyAI = renderer.targetNode
			entity.add_to_group("Monster")
			entity.hasAI = true
