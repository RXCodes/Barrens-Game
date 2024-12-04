static func setup() -> void:
	var item = Item.Entity.new()
	item.identifier = "MolotovCocktail"
	item.displayName = "Molotov Cocktail"
	item.description = "deals lingering burning damage to enemies"
	item.itemTexture = preload("res://Items/MolotovCocktail.png")
	item.onConsume = onConsume
	item.consumeTest = consumeTest
	item.consumable = true
	Item.registerItem(item)

static func onConsume() -> void:
	var molotov: MolotovCocktail = EnemySpawner.spawnEnemy("MolotovCocktail", Player.current.global_position)
	molotov.goToPosition(Crosshair.current.cursorPosition)

static func consumeTest() -> bool:
	return true
