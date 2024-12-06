extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# add this node to the scene so this node can run over time
	NodeRelations.rootNode.add_child(self)
	
	# spawn 5 ammo
	for i in range(5):
		EnemySpawner.spawnEnemy("AmmoPickup", Player.current.global_position)
		await TimeManager.wait(0.2)
	
	# free this node when done
	queue_free()
