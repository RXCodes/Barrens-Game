static func setup() -> void:
	var item = Item.Entity.new()
	item.identifier = "WeaponUpgradeKit"
	item.displayName = "Weapon Upgrade Kit"
	item.description = "Upgrade your weapon's rarity"
	item.itemTexture = preload("res://Items/WeaponUpgradeKit.png")
	item.onConsume = onConsume
	item.consumable = true
	item.removeWhenConsumed = false
	ConfirmationPrompt.onAccept("upgradeWeapon", confirmWeaponUpgrade)
	Item.registerItem(item)

static func onConsume() -> void:
	var selectedGun = Player.current.gunInteractor.currentWeapon
	var selectedGunName = selectedGun.displayName
	GamePopup.openPopup("ConfirmationPrompt", {
		"title": "Upgrade Weapon",
		"description": "Upgrade your " + selectedGunName + " to the next rarity?",
		"cancelText": "Cancel",
		"confirmText": "Upgrade",
		"signalID": "upgradeWeapon"
	})

static func confirmWeaponUpgrade() -> void:
	var selectedGun = Player.current.gunInteractor.currentWeapon
	if selectedGun.rarity == Gun.Rarity.GOLD:
		TextAlert.setupAlert("Your weapon is already at the highest rarity", Color.TOMATO)
		return
	InventoryManager.consumeItem()
	TextAlert.setupAlert("Your weapon has been upgraded!", Color.GOLD)
	var newGun = Gun.gunFromString(selectedGun.fileName)
	newGun.leftoverAmmoCount = selectedGun.leftoverAmmoCount
	if selectedGun.rarity == Gun.Rarity.COMMON:
		newGun.setWeaponRarity(Gun.Rarity.SILVER)
	if selectedGun.rarity == Gun.Rarity.SILVER:
		newGun.setWeaponRarity(Gun.Rarity.GOLD)
	Player.current.replaceGun(newGun)
