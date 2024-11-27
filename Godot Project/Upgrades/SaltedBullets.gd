extends Upgrade

func onUpgrade() -> void:
	# increase damage by 5%
	Player.current.gunInteractor.damageMultiplier += 0.05
	incrementUpgradeStat(5)
