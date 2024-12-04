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
	var grenade: Grenade = EnemySpawner.spawnEnemy("Grenade", Player.current.global_position)
	grenade.goToPosition(Crosshair.current.cursorPosition)

static func consumeTest() -> bool:
	return true
