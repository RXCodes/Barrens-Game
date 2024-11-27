extends Upgrade

func onUpgrade() -> void:
	# increase fire rate by 5%
	Player.current.gunInteractor.fireRateDivisor += 0.05
	incrementUpgradeStat(5)
