extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase bounty for enemies by (amount)%
	Player.current.bountyMultiplier += amounts[0] / 100.0
	incrementUpgradeStat(amounts[0])
