extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase movement speed by (amount)%
	Player.current.movementSpeedMultiplier += amounts[0] / 100.0
	incrementUpgradeStat(amounts[0])
