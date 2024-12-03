static func setup() -> void:
	var item = Item.Entity.new()
	item.identifier = "Grenade"
	item.displayName = "Grenade"
	item.description = "deals extreme area damage to enemies"
	item.itemTexture = preload("res://Items/Grenade.png")
	item.onConsume = onConsume
	item.consumeTest = consumeTest
	item.consumable = true
	Item.registerItem(item)

static func onConsume() -> void:
	print("throw grenade")

static func consumeTest() -> bool:
	return true
