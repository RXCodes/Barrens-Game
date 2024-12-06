extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# set reload speed multiplier to 1.0 (normally 0.5)
	Player.current.reloadMovementSpeedMultiplier = 1.0
	incrementUpgradeStat(amounts[0])
	
