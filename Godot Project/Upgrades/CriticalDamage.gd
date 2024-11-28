extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase critical hit chance by (amount)%
	Player.current.criticalDamageMultiplier += amounts[0] / 100.0
	incrementUpgradeStat(amounts[0])
