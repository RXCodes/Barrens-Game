class_name ShopInteractor extends VBoxContainer

# Called when the node enters the scene tree for the first time.
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
	$"../../../BuyButton/Price".text = str(selectedShopItem.price)
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
	var price = selectedShopItem.price
	if playerCash >= price:
		Player.current.pickupCash(-price)
		selectedShopItem.purchasedItem()
		$"../../../../../Purchase".play()
		if selectedShopItem.type == ShopItem.ItemType.ITEM:
			EnemySpawner.spawnEnemy(selectedShopItem.itemIdentifier, Player.current.global_position + Vector2(0, 15))
			GamePopup.closeCurrent()
		if selectedShopItem.type == ShopItem.ItemType.GUN:
			var newGun = Gun.gunFromString(selectedShopItem.itemIdentifier)
			EnemySpawner.spawnWeapon(newGun, Player.current.global_position)
			GamePopup.closeCurrent()
		if selectedShopItem.type == ShopItem.ItemType.UPGRADE:
			pass # upgrade whatever
	else:
		MoneyDisplay.error()
		$"../../../../../Error".play()
	refreshShopItems()
