class_name ShopInteractor extends VBoxContainer

# Called when the node enters the scene tree for the first time.
var shopItemDisplays: Array
func _ready() -> void:
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

func selectItem(selectShopItemDisplay: ShopItemDisplay) -> void:
	var selectedShopItem = selectShopItemDisplay.shopItem
	$"../../../Title".text = selectedShopItem.displayName
	$"../../../Description".text = selectedShopItem.description
	$"../../../../../Click".play()
	for itemNode: ShopItemDisplay in shopItemDisplays:
		if itemNode == selectShopItemDisplay:
			itemNode.select()
		else:
			itemNode.deselect()
