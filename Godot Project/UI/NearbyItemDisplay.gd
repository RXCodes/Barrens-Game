class_name NearbyItemDisplay extends Control

var item: NearbyItemsListInteractor.ItemPickup

func setupWithItemPickUp(itemPickUp: NearbyItemsListInteractor.ItemPickup) -> void:
	item = itemPickUp
	$Shop/Title.text = itemPickUp.displayName
	$ItemFrame/Mask/Preview.texture = itemPickUp.texture
	$ItemFrame/Amount.text = "x" + str(itemPickUp.amount)
	$ItemFrame/Amount.visible = itemPickUp.amount != 1
	if itemPickUp.type == NearbyItemsListInteractor.ItemType.WEAPON:
		$Shop/Type.text = "Weapon"
	elif itemPickUp.type == NearbyItemsListInteractor.ItemType.ITEM:
		$Shop/Type.text = "Item"

func _on_button_mouse_entered() -> void:
	$".".modulate = Color(0.9, 0.9, 0.9, 1.0)
	Crosshair.hoveringOverButton = true

func _on_button_mouse_exited() -> void:
	$".".modulate = Color.WHITE

func _on_button_button_down() -> void:
	Crosshair.hoveringOverButton = true
	NearbyItemsListInteractor.pickupItem(item)
