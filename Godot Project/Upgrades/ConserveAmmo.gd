extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# decrease ammo consumption by (amount)%
	Player.current.gunInteractor.ammoConsumptionDecrease += amounts[0]
	incrementUpgradeStat(amounts[0])
