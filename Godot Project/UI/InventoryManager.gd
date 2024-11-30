class_name InventoryManager extends Node2D

static var slots = []
static var currentSlotIndex = -1
static var itemName: Label
static var itemDescription: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	itemName = $ItemName
	itemDescription = $ItemDescription
	await get_tree().physics_frame
	
	# create slots (keys 3 to 7)
	slots.append($Slot)
	var separation = 104
	$Slot.setupSlot(3)
	var slotIndex = 4
	for i in range(4):
		var newSlot: InventorySlot = $Slot.duplicate()
		add_child(newSlot)
		newSlot.position.x += (i + 1) * separation
		slots.append(newSlot)
		newSlot.setupSlot(slotIndex)
		slotIndex += 1
	selectSlot(-1)

static func selectSlot(index: int) -> void:
	for slot in slots:
		slot.deselect()
	if index == currentSlotIndex or index < 0:
		currentSlotIndex = -1
		hideItemInfo()
		return
	currentSlotIndex = index
	var selectedSlot: InventorySlot = slots[index]
	selectedSlot.select()
	showItemInfo()

static func showItemInfo() -> void:
	var selectedSlot: InventorySlot = slots[currentSlotIndex]
	var item = selectedSlot.itemEntity
	if not item:
		return
	itemDescription.text = item.description
	itemName.text = item.displayName
	itemDescription.show()
	itemName.show()

static func hideItemInfo() -> void:
	itemDescription.hide()
	itemName.hide()

func _input(event: InputEvent) -> void:
	if GamePopup.current or TutorialManager.shouldDisableControls:
		return
	if not event.is_pressed():
		return
	if event is InputEventKey:
		var key = event.as_text()
		match key:
			"3": selectSlot(0)
			"4": selectSlot(1)
			"5": selectSlot(2)
			"6": selectSlot(3)
			"7": selectSlot(4)
			
