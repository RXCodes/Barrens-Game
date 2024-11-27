extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase reload speed by (amount)%
	Player.current.reloadSpeedDivisor += amounts[0] / 100.0
	incrementUpgradeStat(amounts[0])
	
