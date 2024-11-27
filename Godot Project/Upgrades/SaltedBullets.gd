extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase damage by (amount)%
	Player.current.gunInteractor.damageMultiplier += amounts[0] / 100.0
	incrementUpgradeStat(amounts[0])
