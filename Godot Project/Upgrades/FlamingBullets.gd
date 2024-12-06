extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# enable flaming bullets
	Player.current.flamingBullets = true
	incrementUpgradeStat(1)
	
