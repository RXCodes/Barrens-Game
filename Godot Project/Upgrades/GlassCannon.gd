extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase damage by (amount)%
	Player.current.gunInteractor.damageMultiplier += amounts[0] / 100.0
	incrementDifferentUpgradeStat("damage", amounts[0])
	
	# decrease defense by (amount2)%
	Player.current.defenseDivisor -= amounts[1] / 100.0
	incrementDifferentUpgradeStat("defense", -amounts[1])
