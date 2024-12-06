extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# give the player 2 to 3 lucky coins
	var luckyCoins = Item.getEntity("LuckyCoin").copy()
	luckyCoins.amount = randi_range(2, 3)
	InventoryManager.pickupItem(luckyCoins)
	
