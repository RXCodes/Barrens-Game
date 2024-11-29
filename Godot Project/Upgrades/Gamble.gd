extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# 50% chance to win, 50% chance to lose
	if randf_range(0, 100) <= 50:
		# won (amount)% total cash
		Player.current.pickupCash(round(Player.current.cash * (amounts[0] / 100.0)))
	else:
		# lost (amount2)% total cash
		Player.current.pickupCash(round(Player.current.cash * (amounts[1] / 100.0)))
