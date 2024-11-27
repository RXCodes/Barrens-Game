class_name UpgradeItemDisplay extends Control

func setupWithUpgradeStruct(struct: Upgrade.UpgradeStruct) -> void:
	$Container/Icon.texture = struct.texture
	$Container/Description.text = struct.getDescription()
