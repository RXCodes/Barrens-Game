extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase maximum inventory stack size to 6 (default is 5)
	InventoryManager.maxStackCount = 6
	incrementUpgradeStat(1)
