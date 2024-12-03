static func setup() -> void:
	var item = Item.Entity.new()
	item.identifier = "EnergyDrink"
	item.displayName = "Energy Drink"
	item.description = "increases stamina recovery rate by 50% for 30 s"
	item.itemTexture = preload("res://Items/EnergyDrink.png")
	item.onConsume = onConsume
	item.consumeTest = consumeTest
	item.consumable = true
	Item.registerItem(item)

static func onConsume() -> void:
	TextAlert.setupAlert("increased stamina recovery rate by 50% for 30 s", Color.DEEP_SKY_BLUE)
	Player.current.sprintRecoveryRate *= 1.5
	await TimeManager.wait(30)
	Player.current.sprintRecoveryRate /= 1.5

static func consumeTest() -> bool:
	return true
