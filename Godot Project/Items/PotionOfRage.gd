static var active = false

static func setup() -> void:
	var item = Item.Entity.new()
	item.identifier = "PotionOfRage"
	item.displayName = "Potion of Rage"
	item.description = "grants 100% critical damage for 15 s"
	item.itemTexture = preload("res://Items/PotionOfRage.png")
	item.onConsume = onConsume
	item.consumeTest = consumeTest
	item.consumable = true
	Item.registerItem(item)

static func onConsume() -> void:
	TextAlert.setupAlert("granted 100% critical damage for 15 s", Color.DEEP_SKY_BLUE)
	Player.current.criticalDamageMultiplier += 100000
	active = true
	await TimeManager.wait(15)
	active = false
	Player.current.criticalDamageMultiplier -= 100000

static func consumeTest() -> bool:
	# cannot consume this potion again if rage is already active
	if active:
		TextAlert.setupAlert("Rage is already active!", Color.TOMATO)
		return false
	return true
