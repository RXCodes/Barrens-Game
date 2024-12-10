static func setup() -> void:
	var luckyCoin = Item.Entity.new()
	luckyCoin.identifier = "LuckyCoin"
	luckyCoin.displayName = "Lucky Coin"
	luckyCoin.description = "Grant a free upgrade"
	luckyCoin.itemTexture = preload("res://Items/LuckyCoin.png")
	luckyCoin.onConsume = onConsume
	luckyCoin.consumeTest = consumeTest
	luckyCoin.consumable = true
	Item.registerItem(luckyCoin)

static func onConsume() -> void:
	GamePopup.openPopup("UpgradeSelection")

static func consumeTest() -> bool:
	if VillageController.current.receivingUpgrade:
		TextAlert.setupAlert("You're already receiving an upgrade - please wait", Color.SKY_BLUE)
		return false
	return true
