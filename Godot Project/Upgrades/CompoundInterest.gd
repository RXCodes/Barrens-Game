extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase compound interest by (amount)%
	Player.current.compoundInterest += amounts[0] / 100.0
	incrementUpgradeStat(amounts[0])
