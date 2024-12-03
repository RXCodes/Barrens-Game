static var active = false

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
	TextAlert.setupAlert("your damage is doubled for 30 s", Color.DEEP_SKY_BLUE)
	active = true
	var addedBuff = Player.current.gunInteractor.damageMultiplier
	Player.current.gunInteractor.damageMultiplier *= 2
	await TimeManager.wait(30)
	Player.current.gunInteractor.damageMultiplier -= addedBuff
	active = false

static func consumeTest() -> bool:
	if active:
		TextAlert.setupAlert("warrior serum is already active!", Color.TOMATO)
	return true
