extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase life steal by (amount)
	Player.current.lifestealAmount += amounts[0]
	incrementUpgradeStat(amounts[0])
	
