extends Upgrade

func onUpgrade() -> void:
	# increase reload speed by 6%
	Player.current.reloadSpeedDivisor += 0.06
	incrementUpgradeStat(6)
	
