extends Upgrade

func onUpgrade(amounts: Array) -> void:
	Player.current.pickupCash(getPayout())
	
func getDescription(amounts: Array) -> String:
	return "Claim " + str(getPayout()) + " cash"

func getPayout() -> int:
	return max(round(sqrt(Player.current.totalCashEarned * 200)), 100)
