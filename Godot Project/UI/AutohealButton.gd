class_name AutohealButton extends TextureButton

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
	
	# if the player is at full health, there's no need to heal
	if round(Player.current.health) == round(Player.current.maximumHealth):
		TextAlert.setupAlert("You're already at full health!", Color.TOMATO)
		return
	
	# check if the player has heals
	var heals = []
	for slot: InventorySlot in InventoryManager.slots:
		if not slot.itemEntity:
			break
		var item: Item.Entity = slot.itemEntity
		if item.identifier == "HealthKit" or item.identifier == "Bandages":
			heals.append(item)
	
	if heals.size() == 0:
		TextAlert.setupAlert("You don't have any heals!", Color.TOMATO)
		return
	
	# determine what item the player should heal with
	var health = Player.current.health
	var maxHealth = Player.current.maximumHealth
	var preferHealthKits = false
	if health / maxHealth < 0.75:
		if  maxHealth - health > 15:
			preferHealthKits = true
	
	# find the slot with the preferred item and consume one of it
	var currentSlotIndex = 0
	for slot: InventorySlot in InventoryManager.slots:
		if not slot.itemEntity:
			break
		var item: Item.Entity = slot.itemEntity
		if preferHealthKits and item.identifier == "HealthKit":
			item.onConsume.call()
			InventoryManager.consumeItemAtIndex(currentSlotIndex)
			return
		if not preferHealthKits and item.identifier == "Bandages":
			item.onConsume.call()
			InventoryManager.consumeItemAtIndex(currentSlotIndex)
			return
		currentSlotIndex += 1
	
	# at this point, use bandages if the player has not healed already
	currentSlotIndex = 0
	for slot: InventorySlot in InventoryManager.slots:
		if not slot.itemEntity:
			break
		var item: Item.Entity = slot.itemEntity
		if item.identifier == "Bandages":
			item.onConsume.call()
			InventoryManager.consumeItemAtIndex(currentSlotIndex)
			return
		currentSlotIndex += 1
	
	TextAlert.setupAlert("You have no heals that can be consumed right now", Color.TOMATO)
