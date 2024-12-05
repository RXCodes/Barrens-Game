class_name PreloadContents

static var upgradeClass = preload("res://Upgrades/Upgrades.gd")

# this needs to be declared for web and windows export
# you can view console to get all item paths
static var preloadedItemPaths = [
	preload("res://Items/Item.tscn"),
	preload("res://Items/Bandages.gd"),
	preload("res://Items/ElixirOfFortune.gd"),
	preload("res://Items/EnergyDrink.gd"), 
	preload("res://Items/Grenade.gd"), 
	preload("res://Items/HealthKit.gd"), 
	preload("res://Items/LuckyCoin.gd"), 
	preload("res://Items/MolotovCocktail.gd"),
	preload("res://Items/PotionOfHealing.gd"), 
	preload("res://Items/PotionOfRage.gd"), 
	preload("res://Items/ShieldSpireSerum.gd"), 
	preload("res://Items/StaminaPotion.gd"), 
	preload("res://Items/WarriorSerum.gd")
]
