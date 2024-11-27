extends Upgrade

func onUpgrade() -> void:
	# increase movement speed by 2.5%
	Player.current.movementSpeedMultiplier += 0.025
	incrementUpgradeStat(2.5)
