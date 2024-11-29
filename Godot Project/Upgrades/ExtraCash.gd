extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase cash drops by (amount)%
	Player.current.enemyCashDropMultiplier += amounts[0] / 100.0
	incrementUpgradeStat(amounts[0])
	
