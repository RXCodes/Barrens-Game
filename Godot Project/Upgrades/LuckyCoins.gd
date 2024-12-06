extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# give the player 0 to 2 lucky coins
	var amount = randi_range(0, 2)
	if amount == 0:
		TextAlert.setupAlert("You didn't get any lucky coins", Color.TOMATO)
		return
	var luckyCoins = Item.getEntity("LuckyCoin").copy()
	luckyCoins.amount = amount
	InventoryManager.pickupItem(luckyCoins)
	
