extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase fire rate by (amount)%
	Player.current.gunInteractor.fireRateDivisor += amounts[0] / 100.0
	incrementUpgradeStat(amounts[0])
