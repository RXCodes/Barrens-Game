static func setup() -> void:
	var luckyCoin = Item.Entity.new()
	luckyCoin.displayName = "Lucky Coin"
	luckyCoin.description = "Grant a free upgrade"
	luckyCoin.itemTexture = preload("res://Items/LuckyCoin.png")
	luckyCoin.onConsume = onConsume
	Item.registerItem("LuckyCoin", luckyCoin)

static func onConsume() -> void:
	GamePopup.openPopup("UpgradeSelection")
