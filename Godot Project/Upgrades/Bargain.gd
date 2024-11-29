extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# decrease shop prices by (amount)%
	Player.current.shopPriceDivisor += amounts[0] / 100.0
	incrementUpgradeStat(amounts[0])
