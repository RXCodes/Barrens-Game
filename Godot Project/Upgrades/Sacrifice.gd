extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# increase damage, fire rate, and reload speed by (amount)%
	Player.current.gunInteractor.damageMultiplier += amounts[0] / 100.0
	incrementDifferentUpgradeStat("damage", amounts[0])
	Player.current.gunInteractor.fireRateDivisor += amounts[0] / 100.0
	incrementDifferentUpgradeStat("fireRate", amounts[0])
	Player.current.gunInteractor.reloadSpeedDivisor += amounts[0] / 100.0
	incrementDifferentUpgradeStat("reloadSpeed", amounts[0])
	
	# decrease maximum health by (amount2)%
	Player.current.maximumHealth -= (amounts[1] / 100.0) * Player.current.maximumHealth
	Upgrade.playerUpgrades["health"] = Player.current.maximumHealth - 100
