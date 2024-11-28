extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase maximum health by (amount)
	Player.current.maximumHealth += amounts[0]
	incrementUpgradeStat(amounts[0])
