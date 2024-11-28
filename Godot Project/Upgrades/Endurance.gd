extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# decrease stamina exhaustion rate by (amount)%
	Player.current.sprintDecreaseRateDivisor += amounts[0] / 100.0
	incrementUpgradeStat(amounts[0])
	
