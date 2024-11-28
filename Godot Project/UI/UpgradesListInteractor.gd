class_name UpgradesListInteractor extends VBoxContainer

func _ready() -> void:
	# setup upgrade items
	var upgradeStructs = Upgrade.getCurrentUpgradeStructs()
	$"../../../NoUpgrades".visible = upgradeStructs.size() == 0
	for item: Upgrade.UpgradeStruct in upgradeStructs:
		var itemDisplay = preload("res://UI/UpgradeItemDisplay.tscn").instantiate()
		itemDisplay.setupWithUpgradeStruct(item)
		add_child(itemDisplay)
	
	# add a little spacer at the end
	var spacer = Control.new()
	spacer.custom_minimum_size = Vector2(0, 25)
	add_child(spacer)
