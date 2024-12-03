static var active = false

static func setup() -> void:
	var item = Item.Entity.new()
	item.identifier = "ElixirOfFortune"
	item.displayName = "Elixir of Fortune"
	item.description = "grants 5x Cash for 60 s"
	item.itemTexture = preload("res://Items/ElixirOfFortune.png")
	item.onConsume = onConsume
	item.consumeTest = consumeTest
	item.consumable = true
	Item.registerItem(item)

static func onConsume() -> void:
	TextAlert.setupAlert("granted 5x cash for 60 s", Color.DEEP_SKY_BLUE)
	var amountAdded = Player.current.enemyCashDropMultiplier * 4.0
	Player.current.enemyCashDropMultiplier += amountAdded
	active = true
	await TimeManager.wait(60)
	active = false
	Player.current.enemyCashDropMultiplier -= amountAdded

static func consumeTest() -> bool:
	if active:
		TextAlert.setupAlert("Elixir of fortune is already active!", Color.TOMATO)
		return false
	return true
