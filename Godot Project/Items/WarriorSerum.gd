static func setup() -> void:
	var item = Item.Entity.new()
	item.identifier = "WarriorSerum"
	item.displayName = "Warrior Serum"
	item.description = "doubles damage for 30 s"
	item.itemTexture = preload("res://Items/WarriorSerum.png")
	item.onConsume = onConsume
	item.consumeTest = consumeTest
	item.consumable = true
	Item.registerItem(item)

static func onConsume() -> void:
	TextAlert.setupAlert("doubled damage for 30 s", Color.DEEP_SKY_BLUE)
	Player.current.gunInteractor.damageMultiplier *= 2
	await TimeManager.wait(30)
	Player.current.gunInteractor.damageMultiplier /= 2

static func consumeTest() -> bool:
	return true
