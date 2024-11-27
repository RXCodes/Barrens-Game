extends Upgrade

func onUpgrade() -> void:
	# increase magazine capacity by 10%
	Player.current.gunInteractor.magazineCapacityMultiplier += 0.1
	incrementUpgradeStat(10)
	
