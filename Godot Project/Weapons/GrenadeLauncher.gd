class_name GrenadeLauncher extends Gun

func fire(holding: bool, angleRadians: float) -> void:
	gunInteractor.gunSprite.texture = gunInteractor.currentWeapon.texture
	if not automatic and holding:
		return
	if not canFire or reloading:
		return
	if currentMagCapacity <= 0:
		return
	if needsCocking:
		if not cockedGun:
			return
		cockedGun = false
	canFire = false
	currentMagCapacity -= 1
	gunInteractor.ammoConsumptionPercent -= gunInteractor.ammoConsumptionDecrease
	if gunInteractor.ammoConsumptionPercent <= 0.0:
		gunInteractor.ammoConsumptionPercent = 100.0
		currentMagCapacity += 1
	lastBulletAngleRadians = angleRadians
	if shootAudioPlayer:
		shootAudioPlayer.pitch_scale = randfn(1.0, shootPitchVariance)
		shootAudioPlayer.play()
	if gunInteractor.onFire:
		gunInteractor.onFire.call()
	for i in range(bulletMultiplier):
		var grenade: GrenadeLauncherShell = EnemySpawner.spawnEnemy("GrenadeLauncherShell", Player.current.global_position)
		var random = Vector2.from_angle(randf_range(0, 360))
		var distance = randf_range(0.0, 25.0)
		random.x *= distance
		random.y *= distance
		grenade.goToPosition(Crosshair.current.cursorPosition + random)
	await TimeManager.wait(fireRate / gunInteractor.fireRateDivisor)
	canFire = true
