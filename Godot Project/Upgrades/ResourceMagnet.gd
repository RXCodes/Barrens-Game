extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase pick up range by (amount)%
	Player.current.pickUpRangeMultiplier += amounts[0] / 100.0
	incrementUpgradeStat(amounts[0])
