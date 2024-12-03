static func setup() -> void:
	var item = Item.Entity.new()
	item.identifier = "StaminaPotion"
	item.displayName = "Stamina Potion"
	item.description = "grants unlimited stamina for 30 s"
	item.itemTexture = preload("res://Items/StaminaPotion.png")
	item.onConsume = onConsume
	item.consumeTest = consumeTest
	item.consumable = true
	Item.registerItem(item)

static func onConsume() -> void:
	TextAlert.setupAlert("granted unlimited stamina for 30 s", Color.DEEP_SKY_BLUE)
	Player.current.unlimitedSprint = true
	await TimeManager.wait(30)
	Player.current.unlimitedSprint = false

static func consumeTest() -> bool:
	if Player.current.unlimitedSprint:
		TextAlert.setupAlert("Unlimited stamina is already active!", Color.TOMATO)
		return false
	return true
