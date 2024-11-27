extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase regenerate rate by (amount)%
	Player.current.regenerationRateMultiplier += amounts[0] / 100.0
	incrementUpgradeStat(amounts[0])
