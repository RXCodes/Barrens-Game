class_name UpgradesListButton extends TextureButton

func _on_mouse_entered() -> void:
	modulate = Color(0.8, 0.8, 0.8)
	Crosshair.hoveringOverButton = true

func _on_mouse_exited() -> void:
	modulate = Color.WHITE
	Crosshair.hoveringOverButton = false

func _on_pressed() -> void:
	if GamePopup.current or TutorialManager.shouldDisableControls:
		return
	get_viewport().set_input_as_handled()
	GamePopup.openPopup("PlayerUpgradesList")
