extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase magazine capacity by (amount)%
	Player.current.gunInteractor.magazineCapacityMultiplier += amounts[0] / 100.0
	incrementUpgradeStat(amounts[0])
	
