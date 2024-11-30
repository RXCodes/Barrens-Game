extends Node

# this is where the game actually happens (waves, enemy spawning, etc.)
signal completedWave

func _ready() -> void:
	# first fade in
	var fadeIn = $"../ScreenUI/FadeIn"
	fadeIn.scale = Vector2(1000, 1000)
	await get_tree().physics_frame
	await TimeManager.wait(0.5)
	TutorialManager.shouldDisableControls = false
	var fadeInTween = NodeRelations.createTween()
	fadeInTween.tween_property(fadeIn, "self_modulate", Color(0, 0, 0, 0), 4.0)

	# here we can start waves
	await TimeManager.wait(4.5)
	WaveDisplay.start(1, 30)
	await TimeManager.wait(30)
	
	var currentWave = 1
	while true:
		waveStarted = true
		spawnEnemies(currentWave)
		await completedWave
		waveStarted = false
		currentWave += 1
		WaveDisplay.start(currentWave, 30)
		await TimeManager.wait(1.5)
		GamePopup.openPopup("UpgradeSelection")
		await TimeManager.wait(30 - 1.5)

var minimumSpawningRadiusSquared = 1000 ** 2
var maximumSpawningRadiusSquared = 2500 ** 2
var targetEnemyCount = 0
var maximumActiveEnemyCount = 60
var spawningEnemies = false
var waveStarted = false

func spawnEnemies(wave: int) -> void:
	# compute the amount of enemies to spawn
	var amountToSpawn = sqrt(((120 * wave) ** 1.1) * wave * 0.3)
	amountToSpawn = clampf(amountToSpawn, 10, 100)
	targetEnemyCount = round(amountToSpawn)
	
	# spawn the enemies
	spawningEnemies = true
	for i in range(round(amountToSpawn)):
		while true:
			# make sure to not exceed enemy count at once
			var enemyCount = get_tree().get_nodes_in_group("Enemy").size()
			if enemyCount > maximumActiveEnemyCount:
				await TimeManager.wait(0.1)
				continue
			
			# determine a random point on the traversable map
			var randomPoint = NavigationServer2D.region_get_random_point($"../NavigationRegion".get_rid(), 1, false)
			
			# check if it is within range of the player, but not too close
			var distanceSquared = Player.current.global_position.distance_squared_to(randomPoint)
			if distanceSquared < minimumSpawningRadiusSquared or distanceSquared > maximumSpawningRadiusSquared:
				await TimeManager.wait(0.1)
				continue
			
			# spawn the enemy
			var enemy = EnemySpawner.spawnEnemy("slime_enemy", randomPoint)
			enemy.add_to_group("Enemy")
			await TimeManager.wait(0.1)
			break
	spawningEnemies = false

func _process(delta: float) -> void:
	# check if the wave is completed
	if not spawningEnemies and waveStarted:
		var enemyCount = get_tree().get_nodes_in_group("Enemy").size()
		if enemyCount == 0:
			completedWave.emit()
