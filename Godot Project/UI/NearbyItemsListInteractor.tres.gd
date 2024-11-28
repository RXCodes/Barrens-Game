class_name NearbyItemsListInteractor extends VBoxContainer

func _ready() -> void:
	# setup upgrade items
	var nearbyItems = Upgrade.getCurrentUpgradeStructs()
	$"../../../NoItems".visible = nearbyItems.size() == 0
	for item: Upgrade.UpgradeStruct in nearbyItems:
		var itemDisplay = preload("res://UI/UpgradeItemDisplay.tscn").instantiate()
		itemDisplay.setupWithUpgradeStruct(item)
		add_child(itemDisplay)
	
	# add a little spacer at the end
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 25)
	add_child(spacer)
