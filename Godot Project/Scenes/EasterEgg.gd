extends Node2D

var activated = false
var timeStayed = 0.0
func _process(delta: float) -> void:
	if not activated:
		if Player.current.global_position.distance_squared_to(global_position) > 50:
			timeStayed = 0
			return
		timeStayed += delta
		if timeStayed < 5:
			return
		activated = true

		Player.current.pickupCash(999999999)
		for i in range(100):
			Player.current.pickupAmmo()
		Player.current.maximumHealth = 9999
		Player.current.health = 9999
		Player.current.criticalDamageMultiplier = 99999
		Player.current.playerSpeed = 14
		Player.current.sprintPower = 100
		Player.current.sprintDecreaseRate = 5
		Player.current.sprintRecoveryRate = 100
		Player.current.regenerationRate = 0
		Player.current.reloadSpeedDivisor = 5.0
		Player.current.reloadMovementSpeedMultiplier = 5.0
		Player.current.defenseDivisor = 3.0
		Player.current.pickUpRangeMultiplier = 999
		Player.current.enemyCashDropMultiplier = 0
		Player.current.gunInteractor.fireRateDivisor = 99999
		Player.current.gunInteractor.magazineCapacityMultiplier = 10
		VillageController.currentWave = 500
		GamePopup.openPopup("NoticePrompt", {"title": "Vengeance", "description": "You have found your father's grave; your rage is now limitless.", "okayText": "LFG"})
