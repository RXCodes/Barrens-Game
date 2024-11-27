class_name UpgradesListButton extends TextureButton

func _on_mouse_entered() -> void:
	modulate = Color(0.8, 0.8, 0.8)

func _on_mouse_exited() -> void:
	modulate = Color.WHITE

func _on_pressed() -> void:
	if GamePopup.current or TutorialManager.shouldDisableControls:
		return
	GamePopup.openPopup("PlayerUpgradesList")
