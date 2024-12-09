class_name UpgradeSelectionManager extends Node

var separation = 390
static var current: UpgradeSelectionManager
static var confirmButton: NinePatchRect
static var banners = []
static var selectedUpgrade: Upgrade
static var active = false
static var selectSound: AudioStreamPlayer
static var appearSound: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# pause the scene
	current = self
	VillageController.pause()
	TutorialManager.shouldDisableControls = true
	await TimeManager.wait(0.05)
	
	# setup 2 more banners
	active = true
	selectedUpgrade = null
	confirmButton = $"../Confirm"
	selectSound = $Select
	appearSound = $Appear
	var middleBanner = $"../Banner"
	var leftBanner = middleBanner.duplicate()
	get_parent().add_child((leftBanner))
	leftBanner.position.x -= separation
	var rightBanner = middleBanner.duplicate()
	get_parent().add_child(rightBanner)
	rightBanner.position.x += separation
	banners = [leftBanner, middleBanner, rightBanner]
	$AnimationPlayer.play("Start")
	await TimeManager.wait(1.2)
	
	# pick 3 random upgrades and populate the banners with them
	var upgrades = Upgrade.pickRandomUpgrades(3)
	for i in range(3):
		var upgrade: Upgrade = upgrades[i]
		var banner: UpgradeBanner = banners[i]
		banner.setupWithUpgrade(upgrade)
		appearSound.pitch_scale = 1.0 + (i / 6.0)
		appearSound.play()
		await TimeManager.wait(0.4)

static func upgradeBannerSelected(banner: UpgradeBanner) -> void:
	selectedUpgrade = banner.currentUpgrade
	confirmButton.self_modulate = Color("#ffb86b")
	selectSound.play()
	for currentBanner: UpgradeBanner in banners:
		currentBanner.deselect()
	banner.select()

static func confirmButtonPressed() -> void:
	if not selectedUpgrade or not active:
		return
	active = false
	Player.current.upgradesReceived += 1
	if not selectedUpgrade.stackable:
		if Upgrade.ignoreUpgradeNames.has(selectedUpgrade.upgradeName):
			Player.current.pickupCash(1000)
			TextAlert.setupAlert("You already have this upgrade - compensated 1,000 cash", Color.CYAN)
			VillageController.unpause()
			GamePopup.closeCurrent()
			await TimeManager.wait(0.1)
			TutorialManager.shouldDisableControls = false
			return
		Upgrade.ignoreUpgradeNames.append(selectedUpgrade.upgradeName)
	selectedUpgrade.onUpgrade(selectedUpgrade.preferredUpgradeAmounts)
	VillageController.unpause()
	if selectedUpgrade.upgradeName == "Gamble":
		await TimeManager.wait(0.1)
		TutorialManager.shouldDisableControls = false
		return
	GamePopup.closeCurrent()
	await TimeManager.wait(0.1)
	TutorialManager.shouldDisableControls = false
