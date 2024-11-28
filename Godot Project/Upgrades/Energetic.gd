extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# decrease stamina recovery rate by (amount)%
	Player.current.sprintRecoveryMultiplier += amounts[0] / 100.0
	incrementUpgradeStat(amounts[0])
	
