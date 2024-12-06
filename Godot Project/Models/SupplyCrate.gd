class_name Crate extends EnemyAI

func onDeath() -> void:
	Item.spawnItem("Bandages", randi_range(1, 3), getPosition())
	Item.spawnItem("HealthKit", randi_range(0, 2), getPosition())
	Item.spawnItem("MolotovCocktail", randi_range(0, 3), getPosition())
	Item.spawnItem("Grenade", randi_range(0, 3), getPosition())
	for i in range(randi_range(2, 3)):
		EnemySpawner.spawnEnemy("AmmoPickup", getPosition())
	for i in range(3):
		var special = ["ElixirOfFortune", "EnergyDrink", "PotionOfHealing", "PotionOfRage", "ShieldSpireSerum", "StaminaPotion", "WarriorSerum"]
		Item.spawnItem(special.pick_random(), 1, getPosition())
