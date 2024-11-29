extends Upgrade

func onUpgrade(amounts: Array) -> void:
	# use player's total cash earned to determine payout
	var payout = max(round(Player.current.totalCashEarned * 0.25) + 500, 1000)
	Player.current.pickupCash(payout)
	
func getDescription(amounts: Array) -> String:
	if not Player.current:
		return "Player not found"
	var payout = max(round(Player.current.totalCashEarned * 0.25) + 500, 1000)
	return "Claim " + str(payout) + " cash"
