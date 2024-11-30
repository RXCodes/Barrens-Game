extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase defense by (amount)
	Player.current.defenseDivisor += amounts[0] / 100.0
	incrementDifferentUpgradeStat("defense", amounts[0])
	
	# decrease movement speed by (amount2)
	Player.current.movementSpeedMultiplier -= amounts[1] / 100.0
	incrementDifferentUpgradeStat("movementSpeed", -amounts[1])
