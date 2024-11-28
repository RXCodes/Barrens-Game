extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# decrease damage from enemies by (amount)%
	Player.current.defenseDivisor += amounts[0] / 100.0
	incrementUpgradeStat(amounts[0])
