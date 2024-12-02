class_name UpgradeBanner extends Sprite2D

var currentUpgrade: Upgrade

func setupWithUpgrade(upgrade: Upgrade) -> void:
	currentUpgrade = upgrade
	var upgradeAmounts = upgrade.preferredUpgradeAmounts
	var amountMultiplier = randf_range(upgrade.minRandomUpgradeAmountMultiplier, upgrade.maxRandomUpgradeAmountMultiplier)
	for i in range(upgradeAmounts.size()):
		upgradeAmounts[i] *= amountMultiplier
		upgradeAmounts[i] = round(upgradeAmounts[i] * 10) / 10
	currentUpgrade.preferredUpgradeAmounts = upgradeAmounts
	$Description.text = upgrade.getDescription(upgradeAmounts)
	$Title.text = upgrade.upgradeName
	$Icon.texture = upgrade.texture
	$AnimationPlayer.play("Summon")
	playExplodeParticleEffect()
	show()

func deselect() -> void:
	self_modulate = Color("#8cc1d6")
	$Description.self_modulate = Color("#cff1ff")

func select() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Select")
	self_modulate = Color("#b2cf9a")
	$Description.self_modulate = Color("#d7f3e0")
	playExplodeParticleEffect()
	modulate = Color.WHITE
	
func playExplodeParticleEffect() -> void:
	var newParticleEffect = $Explode.duplicate()
	add_child(newParticleEffect)
	newParticleEffect.emitting = true
	await TimeManager.wait(2.5)
	newParticleEffect.queue_free()

func _on_button_mouse_entered() -> void:
	modulate = Color(0.8, 0.8, 0.8)
	
func _on_button_mouse_exited() -> void:
	modulate = Color.WHITE

func _on_button_button_down() -> void:
	UpgradeSelectionManager.upgradeBannerSelected(self)
