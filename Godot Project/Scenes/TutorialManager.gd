class_name TutorialManager extends Node

static var shouldDisableControls = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var fadeIn = $"../ScreenUI/FadeIn"
	fadeIn.scale = Vector2(1000, 1000)
	var primaryGun: Gun = Player.current.holdingWeapons[0]
	primaryGun.leftoverAmmoCount = 0
	primaryGun.currentMagCapacity = 0
	AmmoInfoDisplay.setAmmoLeft(0)
	AmmoInfoDisplay.setMagCapacity(0)
	shouldDisableControls = true
	await get_tree().physics_frame
	var fadeInTween = NodeRelations.createTween()
	fadeInTween.tween_property(fadeIn, "self_modulate", Color(0, 0, 0, 0), 4.0)
	await TimeManager.wait(3.5)
	GamePopup.openPopup("TutorialMovementControls")
	shouldDisableControls = false
	await $"../TutorialTrigger1".body_entered
	GamePopup.openPopup("TutorialSprinting")
	await $"../TutorialTrigger2".body_entered
	GamePopup.openPopup("TutorialGunUsage")
