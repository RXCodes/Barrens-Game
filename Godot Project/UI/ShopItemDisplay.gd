class_name ShopItemDisplay extends Control

var shopItem: ShopItem
var currentShop: ShopInteractor

func setupWithShopItemNode(newShopItem: ShopItem, shop: ShopInteractor) -> void:
	shopItem = newShopItem
	currentShop = shop
	shopItem.shopInteractor = currentShop
	$Shop/Title.text = shopItem.displayName
	$ItemFrame/Mask/Amount.text = "x" + str(shopItem.amount)
	$ItemFrame/Mask/Amount.visible = shopItem.amount > 1
	$ItemFrame/Mask/Preview.texture = shopItem.displayTexture
	$ItemFrame/Mask/Preview.offset = shopItem.displayTextureOffset
	$ItemFrame/Mask/Preview.scale = Vector2(shopItem.displayScale, shopItem.displayScale)
	if shopItem.type == ShopItem.ItemType.GUN:
		$Shop/ItemType.text = "Weapon"
	elif shopItem.type == ShopItem.ItemType.ITEM:
		$Shop/ItemType.text = "Item"
	elif shopItem.type == ShopItem.ItemType.UPGRADE:
		$Shop/ItemType.text = "Upgrade"
	else:
		$Shop/ItemType.text = "Special"
	refresh()
				
func refresh() -> void:
	$ItemFrame/Mask/SlotInfo.hide()
	$Shop/Description.text = shopItem.getDescription()
	$ItemFrame/Mask/SlotInfo.self_modulate = Color.WHITE
	$Shop/Cost.text = str(ceil(shopItem.price / Player.current.shopPriceDivisor))
	if shopItem.limitSales:
		if shopItem.limitAmount > 1:
			$ItemFrame/Mask/SlotInfo.show()
		$ItemFrame/Mask/SlotInfo.text = str(shopItem.itemsLeft) + " Left"
		if shopItem.canRestock:
			$ItemFrame/Mask/SlotInfo.hide()
		if shopItem.itemsLeft == 0:
			$ItemFrame/Mask/SlotInfo.show()
			if shopItem.canRestock:
				$ItemFrame/Mask/SlotInfo.text = "Restocking"
				$ItemFrame/Mask/SlotInfo.self_modulate = Color.LEMON_CHIFFON
			else:
				$ItemFrame/Mask/SlotInfo.text = "Sold Out"
				$ItemFrame/Mask/SlotInfo.self_modulate = Color.LIGHT_CORAL

func _on_button_button_down() -> void:
	currentShop.selectItem(self)

func deselect() -> void:
	$Shop.self_modulate = Color("#b57991")
	
func select() -> void:
	$Shop.self_modulate = Color("#d8acbc")

func _on_button_mouse_entered() -> void:
	$".".modulate = Color(0.9, 0.9, 0.9, 1.0)

func _on_button_mouse_exited() -> void:
	$".".modulate = Color.WHITE
