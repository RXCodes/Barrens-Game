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
	Player.current.enemyCashDropMultiplier *= 5.0
	await TimeManager.wait(60)
	Player.current.enemyCashDropMultiplier /= 5.0

static func consumeTest() -> bool:
	return true
