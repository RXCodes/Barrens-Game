static func setup() -> void:
	var item = Item.Entity.new()
	item.identifier = "Bandages"
	item.displayName = "Bandages"
	item.description = "Restores 10 HP"
	item.itemTexture = preload("res://Items/Bandages.png")
	item.onConsume = onConsume
	item.consumeTest = consumeTest
	item.consumable = true
	Item.registerItem(item)

static func onConsume() -> void:
	TextAlert.setupAlert("Restored 10 HP", Color.LIGHT_GREEN)
	Player.current.health += 10

static func consumeTest() -> bool:
	# player must be below max healh
	if Player.current.health >= Player.current.maximumHealth:
		TextAlert.setupAlert("You're already at full health!", Color.TOMATO)
		return false
	return true
