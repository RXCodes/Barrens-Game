class_name ItemPickupButton extends TextureButton

func _on_mouse_entered() -> void:
	modulate = Color(0.8, 0.8, 0.8)
	Crosshair.hoveringOverButton = true

func _on_mouse_exited() -> void:
	modulate = Color.WHITE
	Crosshair.hoveringOverButton = false

func _ready() -> void:
	$"../ItemDropdown".hide()
	self.show()

func _on_pressed() -> void:
	if GamePopup.current or TutorialManager.shouldDisableControls:
		return
	
	# toggle visibility of button and dropdown
	NearbyItemsListInteractor.showingDropdown = true
	$"../ItemDropdown".show()
	self.hide()
	if not visible and Crosshair.hoveringOverButton:
		Crosshair.hoveringOverButton = false
