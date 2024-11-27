extends Upgrade

func onUpgrade() -> void:
	# increase critical hit chance by 25%
	Player.current.criticalDamageMultiplier += 0.25
	incrementUpgradeStat(25)
