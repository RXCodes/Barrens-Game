class_name UpgradeItemDisplay extends Control

func setupWithUpgradeStruct(struct: Upgrade.UpgradeStruct) -> void:
	$Container/Icon.texture = struct.texture
	$Container/Description.text = struct.getDescription()
	if struct.isNegative():
		$Container/Icon.self_modulate = Color.TOMATO
		$Container/Description.self_modulate = Color.TOMATO
		$Container.self_modulate = Color("#bd7463")
