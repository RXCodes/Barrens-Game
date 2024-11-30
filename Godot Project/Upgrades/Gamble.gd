extends Upgrade

func onUpgrade(amounts: Array) -> void:	
	# 50% chance to win, 50% chance to lose
	if randf_range(0, 100) <= 50:
		# won (amount)% total cash
		var reward = round(Player.current.cash * (amounts[0] / 100.0))
		Player.current.pickupCash(reward)
		GamePopup.openPopup("NoticePrompt", {
			"title": "Gamble Results",
			"description": "You got " + str(reward) + " cash!",
			"okayText": "Nice!"
		})
	else:
		# lost (amount2)% total cash
		var loss = round(Player.current.cash * (amounts[1] / 100.0))
		Player.current.pickupCash(-loss)
		GamePopup.openPopup("NoticePrompt", {
			"title": "Gamble Results",
			"description": "You lost " + str(loss) + " cash. Better luck next time.",
			"okayText": "Close"
		})
