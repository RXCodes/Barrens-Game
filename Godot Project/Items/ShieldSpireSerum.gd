static func setup() -> void:
	var item = Item.Entity.new()
	item.identifier = "ShieldSpireSerum"
	item.displayName = "Shieldspire Serum"
	item.description = "grants 30% defense for 20 s"
	item.itemTexture = preload("res://Items/ShieldSpireSerum.png")
	item.onConsume = onConsume
	item.consumeTest = consumeTest
	item.consumable = true
	Item.registerItem(item)

static func onConsume() -> void:
	TextAlert.setupAlert("granted 30% defense for 20 s", Color.DEEP_SKY_BLUE)
	Player.current.defenseDivisor += 0.3
	await TimeManager.wait(20)
	Player.current.defenseDivisor -= 0.3

static func consumeTest() -> bool:
	return true
