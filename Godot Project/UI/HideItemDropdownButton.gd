extends TextureButton

func _on_pressed() -> void:
	if GamePopup.current or TutorialManager.shouldDisableControls:
		return
	
	# toggle visibility of button and dropdown
	NearbyItemsListInteractor.showingDropdown = false
	$"../../../ItemButton".show()
	$"../..".hide()
	Crosshair.hoveringOverButton = false
