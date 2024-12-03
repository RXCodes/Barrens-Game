static func setup() -> void:
	var item = Item.Entity.new()
	item.identifier = "PotionOfHealing"
	item.displayName = "Potion of Healing"
	item.description = "grants 5x health regeneration for 15 s"
	item.itemTexture = preload("res://Items/PotionOfHealing.png")
	item.onConsume = onConsume
	item.consumeTest = consumeTest
	item.consumable = true
	Item.registerItem(item)

static func onConsume() -> void:
	TextAlert.setupAlert("granted 5x health regeneration for 15 s", Color.DEEP_SKY_BLUE)
	Player.current.regenerationRate *= 5
	await TimeManager.wait(15)
	Player.current.regenerationRate /= 5

static func consumeTest() -> bool:
	return true
