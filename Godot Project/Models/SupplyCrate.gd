class_name Crate extends EnemyAI

var cashDropped = 0
func onDamage() -> void:
	var cashDropAmount = (maxHealth - currentHealth) / 10.0
	var cashToDrop = round(cashDropAmount - cashDropped)
	if cashToDrop > 0:
		EnemySpawner.spawnMoney(cashToDrop, getPosition())
	cashDropped = cashDropAmount

func onDeath() -> void:
	# spawn some random items
	Item.spawnItem("Bandages", randi_range(1, 3), getPosition())
	Item.spawnItem("HealthKit", randi_range(0, 2), getPosition())
	Item.spawnItem("MolotovCocktail", randi_range(0, 3), getPosition())
	Item.spawnItem("Grenade", randi_range(0, 3), getPosition())
	for i in range(randi_range(2, 3)):
		EnemySpawner.spawnEnemy("AmmoPickup", getPosition())
	for i in range(3):
		var special = ["ElixirOfFortune", "EnergyDrink", "PotionOfHealing", "PotionOfRage", "ShieldSpireSerum", "StaminaPotion", "WarriorSerum"]
		Item.spawnItem(special.pick_random(), 1, getPosition())
	
	# chance to spawn a weapon
	if randi_range(1, 5) == 1:
		var gun = Gun.gunFromString("UMP45")
		EnemySpawner.spawnWeapon(gun, getPosition())
	if randi_range(1, 10) == 1:
		var gun = Gun.gunFromString("AK47")
		EnemySpawner.spawnWeapon(gun, getPosition())
	if randi_range(1, 25) == 1:
		var gun = Gun.gunFromString("MachineGun")
		EnemySpawner.spawnWeapon(gun, getPosition())
	if randi_range(1, 50) == 1:
		var gun = Gun.gunFromString("ScarL")
		EnemySpawner.spawnWeapon(gun, getPosition())
	if randi_range(1, 50) == 1:
		var gun = Gun.gunFromString("GrenadeLauncher")
		EnemySpawner.spawnWeapon(gun, getPosition())
