class_name VillageController extends Node

# this is where the game actually happens (waves, enemy spawning, etc.)
signal completedWave
signal finishedSpawningEnemies
static var currentWave = 1
func _ready() -> void:
	# first fade in
	var fadeIn = $"../ScreenUI/FadeIn"
	fadeIn.scale = Vector2(1000, 1000)
	currentWave = 1
	await get_tree().physics_frame
	await TimeManager.wait(0.5)
	TutorialManager.shouldDisableControls = false
	var fadeInTween = NodeRelations.createTween()
	fadeInTween.tween_property(fadeIn, "self_modulate", Color(0, 0, 0, 0), 4.0)

	# here we can start waves
	await TimeManager.wait(4.5)
	WaveDisplay.start(1, 30)
	prepareEnemies()
	await TimeManager.wait(30)
	
	# the game loop: prepare enemies -> wait -> spawn enemies -> wait for player to complete wave -> repeat
	while true:
		waveStarted = true
		spawnEnemies()
		await finishedSpawningEnemies
		await completedWave
		waveStarted = false
		currentWave += 1
		var earnings = round(Player.current.compoundInterest * Player.current.cash)
		earnings += max(currentWave * 25, 200)
		Player.current.pickupCash(earnings)
		WaveDisplay.start(currentWave, 25)
		Player.current.wavesCompleted += 1
		await TimeManager.wait(1.5)
		GamePopup.openPopup("UpgradeSelection")
		prepareEnemies()
		await TimeManager.wait(25 - 1.5)

var minimumSpawningRadiusSquared = 1000 ** 2
var maximumSpawningRadiusSquared = 2500 ** 2
var targetEnemyCount = 0
var maximumActiveEnemyCount = 60
var waveStarted = false
var enemyObjectPool = []

# asychronously instantiate enemy objects on another thread
func prepareEnemies() -> void:
	# compute the amount of enemies to spawn
	var amountToSpawn = sqrt(((80 * currentWave) ** 1.1) * currentWave * 0.3)
	amountToSpawn = clampf(amountToSpawn, 10, 100)
	targetEnemyCount = round(amountToSpawn)
	
	# prepare an array of enemy names that will spawn
	enemyObjectPool.clear()
	var enemySpawnEntries = []
	var possibleEnemyTypes = determineEnemies()
	enemySpawnEntries = []
	for i in range(round(amountToSpawn)):
		enemySpawnEntries.append(possibleEnemyTypes.pick_random())
	
	# now create all the enemies in another thread
	# this prevents performance drops while instantiating massive amounts of enemies
	var batchRequest = EnemySpawner.batchInstantiateEnemies(enemySpawnEntries)
	await batchRequest.completed
	enemyObjectPool = batchRequest.nodes
	
# spawn all the enemies into the map
func spawnEnemies() -> void:
	for enemy: Node2D in enemyObjectPool:
		while true:

			# determine a random point on the traversable map
			var randomPoint = getRandomSpawnPoint()
			
			# check if it is within range of the player, but not too close
			var distanceSquared = Player.current.global_position.distance_squared_to(randomPoint)
			if distanceSquared < minimumSpawningRadiusSquared or distanceSquared > maximumSpawningRadiusSquared:
				await TimeManager.wait(0.01)
				continue
			
			# add the enemy to the scene then move on to the next enemy
			NodeRelations.rootNode.find_child("Level").add_child(enemy)
			enemy.add_to_group("Enemy")
			enemy.position = randomPoint
			await TimeManager.wait(0.01)
			break
	finishedSpawningEnemies.emit()

# determine what enemies should be spawned for a particular wave
# adjust how frequent a particular enemy spawns by adding more entries
func determineEnemies() -> Array:
	var enemyNames = ["slime_enemy"]
	if currentWave >= 2:
		enemyNames.append("slime_enemy")
	if currentWave >= 3:
		enemyNames.append("manta_ray_enemy")
		enemyNames.append("acid_slime_enemy")
	if currentWave >= 5:
		enemyNames.append("slime_enemy")
		enemyNames.append("scorpion_enemy")
	if currentWave >= 7:
		enemyNames.append("slime_enemy")
		enemyNames.append("manta_ray_enemy")
		enemyNames.append("snake_enemy")
	if currentWave >= 10:
		enemyNames.append("worm_enemy")
	return enemyNames

# get a random point on the traversable map
func getRandomSpawnPoint() -> Vector2:
	var navigationRegion = $"../NavigationRegions/Spawn"
	return NavigationServer2D.region_get_random_point(navigationRegion.get_rid(), 1, false)

func _process(delta: float) -> void:
	# check if the wave is completed
	if waveStarted:
		var enemyCount = get_tree().get_nodes_in_group("Enemy").size()
		if enemyCount == 0:
			completedWave.emit()
