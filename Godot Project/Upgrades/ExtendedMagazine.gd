extends Upgrade

func onUpgrade() -> void:
	# increase magazine capacity by 10%
	Player.current.gunInteractor.magazineCapacityMultiplier *= 1.1
	incrementUpgradeStat(10)
	
