class_name ShopInteractor extends VBoxContainer

var shopItemDisplays: Array

func _ready() -> void:
	# hide buy button
	$"../../../BuyButton".hide()
	
	# setup shop items
	var shopItemNodes = GamePopup.current.data["shopItems"]
	for item: ShopItem in shopItemNodes:
		var shopItemDisplay = preload("res://UI/ShopItemDisplay.tscn").instantiate()
		shopItemDisplays.append(shopItemDisplay)
		add_child(shopItemDisplay)
		shopItemDisplay.setupWithShopItemNode(item, self)
	
	# add a little spacer at the end
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 25)
	add_child(spacer)

var selectedShopItem: ShopItem
var selectedShopItemDisplay: ShopItemDisplay
func selectItem(newItemDisplay: ShopItemDisplay) -> void:
	if newItemDisplay == null:
		return
	if selectedShopItemDisplay != newItemDisplay:
		$"../../../../../Click".play()
	selectedShopItemDisplay = newItemDisplay
	selectedShopItem = selectedShopItemDisplay.shopItem
	$"../../../BuyButton".show()
	$"../../../Title".text = selectedShopItem.displayName
	$"../../../Description".text = selectedShopItem.description
	$"../../../BuyButton/Price".text = str(ceil(selectedShopItem.price / Player.current.shopPriceDivisor))
	for itemNode: ShopItemDisplay in shopItemDisplays:
		if itemNode == selectedShopItemDisplay:
			itemNode.select()
		else:
			itemNode.deselect()
	if selectedShopItem.itemsLeft == 0:
		$"../../../BuyButton".hide()

func refreshShopItems() -> void:
	for itemNode: ShopItemDisplay in shopItemDisplays:
		itemNode.refresh()
	selectItem(selectedShopItemDisplay)

# shop button methods
func _on_button_mouse_entered() -> void:
	$"../../../BuyButton".modulate = Color(0.9, 0.9, 0.9)

func _on_button_mouse_exited() -> void:
	$"../../../BuyButton".modulate = Color.WHITE

func _on_button_button_down() -> void:
	var playerCash = Player.current.cash
	var price = ceil(selectedShopItem.price /  Player.current.shopPriceDivisor)
	if playerCash >= price:
		Player.current.pickupCash(-price)
		selectedShopItem.purchasedItem()
		$"../../../../../Purchase".play()
		for i in range(selectedShopItem.amount):
			if selectedShopItem.type == ShopItem.ItemType.ITEM:
				EnemySpawner.spawnEnemy(selectedShopItem.itemIdentifier, Player.current.global_position + Vector2(0, 15))
				GamePopup.closeCurrent()
			if selectedShopItem.type == ShopItem.ItemType.GUN:
				var newGun = Gun.gunFromString(selectedShopItem.itemIdentifier)
				EnemySpawner.spawnWeapon(newGun, Player.current.global_position)
				await get_tree().physics_frame
				newGun.currentMagCapacity = newGun.maximumMagCapacity
				newGun.leftoverAmmoCount = newGun.maximumMagCapacity * 2
				GamePopup.closeCurrent()
			if selectedShopItem.type == ShopItem.ItemType.UPGRADE:
				var newUpgrade: Upgrade = load("res://Upgrades/" + selectedShopItem.itemIdentifier + ".tscn").instantiate()
				var upgradeAmounts = newUpgrade.preferredUpgradeAmounts
				for s in range(selectedShopItem.upgradeAmounts.size()):
					upgradeAmounts[s] = selectedShopItem.upgradeAmounts[s]
				Player.current.upgradesReceived += 1
				newUpgrade.onUpgrade(upgradeAmounts)
				newUpgrade.queue_free()
			if selectedShopItem.type == ShopItem.ItemType.LUCKY_COIN:
				GamePopup.openPopup("UpgradeSelection")
	else:
		MoneyDisplay.error()
		$"../../../../../Error".play()
	refreshShopItems()
