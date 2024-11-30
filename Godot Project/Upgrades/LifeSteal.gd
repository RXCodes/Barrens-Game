extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase life steal by (amount)%
	Player.current.lifestealMultiplier += amounts[0] / 100.0
	incrementUpgradeStat(amounts[0])
	
