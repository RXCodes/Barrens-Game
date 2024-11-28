class_name NearbyItemsListInteractor extends VBoxContainer

static var showingDropdown: bool = false:
	set(showing):
		showingDropdown = showing
		clickSound.play()
static var current: NearbyItemsListInteractor
static var clickSound: AudioStreamPlayer
var scanRadius = 75
var discoveredItems = []

func _ready() -> void:
	clickSound = $"../../../Click"
	current = self
	await get_tree().physics_frame
	
	# add a little spacer at the end
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 15)
	add_child(spacer)
	
	while not Player.current.dead:
		# slight delay
		await TimeManager.wait(0.1)
		
		# scan for items, search for new weapons first
		var weaponItems = get_tree().get_nodes_in_group("Weapon")
		for weapon: WeaponEntity in weaponItems:
			if weapon in discoveredItems:
				continue
			var distanceSquared = Player.current.global_position.distance_squared_to(weapon.global_position)
			if distanceSquared > (scanRadius * Player.current.pickUpRangeMultiplier) ** 2:
				continue
			discoveredItems.append(weapon)
			var newItemPickup = ItemPickup.new()
			newItemPickup.displayName = weapon.gun.displayName
			newItemPickup.texture = weapon.gun.texture
			newItemPickup.correspondingNode = weapon
			weapon.pickupItem = newItemPickup
			var itemDisplay = preload("res://UI/NearbyItemDisplay.tscn").instantiate()
			itemDisplay.setupWithItemPickUp(newItemPickup)
			newItemPickup.itemDisplay = itemDisplay
			add_child(itemDisplay)
			move_child(spacer, discoveredItems.size())
			
		# iterate through all discovered items to make sure they're still within range
		for item: Node2D in discoveredItems:
			var distanceSquared = Player.current.global_position.distance_squared_to(item.global_position)
			if distanceSquared <= (scanRadius * Player.current.pickUpRangeMultiplier) ** 2:
				continue
			item.pickupItem.itemDisplay.queue_free()
			discoveredItems.erase(item)
			
		# when there's no item, show indication
		$"../../../NoItems".visible = discoveredItems.size() == 0

static func pickupItem(itemPickup: ItemPickup) -> void:
	if itemPickup.type == ItemType.WEAPON:
		itemPickup.itemDisplay.queue_free()
		current.discoveredItems.erase(itemPickup.correspondingNode)
		Player.current.pickupWeapon(itemPickup.correspondingNode.gun)
		itemPickup.correspondingNode.queue_free()
		clickSound.play()

func _on_touch_absorber_mouse_entered() -> void:
	Crosshair.hoveringOverButton = true

func _on_touch_absorber_mouse_exited() -> void:
	Crosshair.hoveringOverButton = false

enum ItemType {WEAPON, CONSUMABLE, THROWABLE}

class ItemPickup:
	var displayName: String
	var amount: int = 1
	var type: ItemType
	var texture: Texture2D
	var itemDisplay: NearbyItemDisplay
	var correspondingNode: Node
