class_name NearbyItemDisplay extends Control

var item: NearbyItemsListInteractor.ItemPickup

func setupWithItemPickUp(itemPickUp: NearbyItemsListInteractor.ItemPickup) -> void:
	item = itemPickUp
	$Shop/Title.text = itemPickUp.displayName
	$ItemFrame/Mask/Preview.material = itemPickUp.shaderMaterial
	$ItemFrame/Mask/Preview.texture = itemPickUp.texture
	$ItemFrame/Mask/Amount.text = "x" + str(itemPickUp.amount)
	$ItemFrame/Mask/Amount.visible = itemPickUp.amount != 1
	if itemPickUp.type == NearbyItemsListInteractor.ItemType.WEAPON:
		$Shop/Type.text = "Weapon"
		$ItemFrame/Mask/Preview.scale = Vector2(0.5, 0.5)
		$ItemFrame/Mask/Preview.offset = Vector2(-18, 0)
	elif itemPickUp.type == NearbyItemsListInteractor.ItemType.ITEM:
		$Shop/Type.text = "Item"
		$ItemFrame/Mask/Preview.scale = Vector2.ONE
		$ItemFrame/Mask/Preview.offset = Vector2.ZERO

func _on_button_mouse_entered() -> void:
	$".".modulate = Color(0.9, 0.9, 0.9, 1.0)
	Crosshair.hoveringOverButton = true

func _on_button_mouse_exited() -> void:
	$".".modulate = Color.WHITE

func _on_button_button_down() -> void:
	Crosshair.hoveringOverButton = true
	NearbyItemsListInteractor.pickupItem(item)
