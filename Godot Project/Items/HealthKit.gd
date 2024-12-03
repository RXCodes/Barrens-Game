static func setup() -> void:
	var item = Item.Entity.new()
	item.identifier = "HealthKit"
	item.displayName = "Health Kit"
	item.description = "Restores full health"
	item.itemTexture = preload("res://Items/HealthKit.png")
	item.onConsume = onConsume
	item.consumeTest = consumeTest
	item.consumable = true
	Item.registerItem(item)

static func onConsume() -> void:
	TextAlert.setupAlert("Restored to full health!", Color.LIGHT_GREEN)
	Player.current.health = Player.current.maximumHealth

static func consumeTest() -> bool:
	# player must be below 75% to use this item
	if Player.current.health > Player.current.maximumHealth * 0.75:
		TextAlert.setupAlert("You must be under 75% health to use this item.", Color.TOMATO)
		return false
	return true
