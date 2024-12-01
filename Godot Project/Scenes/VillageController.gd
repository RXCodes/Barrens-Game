class_name VillageController extends Node

# this is where the game actually happens (waves, enemy spawning, etc.)
signal completedWave
static var currentWave = 1
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
	
	while true:
		waveStarted = true
		spawnEnemies(currentWave)
		await completedWave
		waveStarted = false
		currentWave += 1
		var earnings = round(Player.current.compoundInterest * Player.current.cash)
		earnings += max(currentWave * 25, 200)
		Player.current.pickupCash(earnings)
		WaveDisplay.start(currentWave, 30)
		Player.current.wavesCompleted += 1
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
				await TimeManager.wait(0.01)
				continue
			
			# determine a random point on the traversable map
			var randomPoint = NavigationServer2D.region_get_random_point($"../NavigationRegions/Small (30px)".get_rid(), 1, false)
			
			# check if it is within range of the player, but not too close
			var distanceSquared = Player.current.global_position.distance_squared_to(randomPoint)
			if distanceSquared < minimumSpawningRadiusSquared or distanceSquared > maximumSpawningRadiusSquared:
				await TimeManager.wait(0.01)
				continue
			
			# spawn the enemy
			var enemyEntries = determineEnemies(wave)
			var enemy = EnemySpawner.spawnEnemy(enemyEntries.pick_random(), randomPoint)
			enemy.add_to_group("Enemy")
			await TimeManager.wait(0.01)
			break
	spawningEnemies = false

# determine what enemies should be spawned for a particular wave
# adjust how frequent a particular enemy spawns by adding more entries
func determineEnemies(wave: int) -> Array:
	var enemyNames = ["slime_enemy"]
	if wave >= 2:
		enemyNames.append("slime_enemy")
	if wave >= 3:
		enemyNames.append("manta_ray_enemy")
		enemyNames.append("acid_slime_enemy")
	if wave >= 5:
		enemyNames.append("slime_enemy")
		enemyNames.append("scorpion_enemy")
	if wave >= 7:
		enemyNames.append("slime_enemy")
		enemyNames.append("manta_ray_enemy")
		enemyNames.append("snake_enemy")
	if wave >= 10:
		enemyNames.append("worm_enemy")
	return enemyNames

func _process(delta: float) -> void:
	# check if the wave is completed
	if not spawningEnemies and waveStarted:
		var enemyCount = get_tree().get_nodes_in_group("Enemy").size()
		if enemyCount == 0:
			completedWave.emit()
