static func setup() -> void:
	var item = Item.Entity.new()
	item.identifier = "MolotovCocktail"
	item.displayName = "Molotov Cocktail"
	item.description = "deals burning damage to enemies"
	item.itemTexture = preload("res://Items/MolotovCocktail.png")
	item.onConsume = onConsume
	item.consumeTest = consumeTest
	item.consumable = true
	Item.registerItem(item)

static func onConsume() -> void:
	print("throw molotov")

static func consumeTest() -> bool:
	return true
