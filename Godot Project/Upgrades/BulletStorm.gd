extends Upgrade

func onUpgrade() -> void:
	# increase fire rate by 5%
	Player.current.gunInteractor.fireRateMultiplier *= 0.95
	incrementUpgradeStat(5)
