class_name Upgrade extends Node

## display name of the upgrade
@export var upgradeName: String

## the description to display - doesn't effect what is shown in the shop
@export var description: String

## accumative description to use when player views their upgrades
## - [amt] will be replaced with the current statistic
@export var accumativeDescription: String

## what identifier this upgrade uses
@export var upgradeIdentifier: String

## the texture this upgrade uses
@export var texture: Texture2D

## can this effect stack? if not, it can only be received once
@export var stackable: bool = true

static var playerUpgrades: Dictionary = {}
static var upgradeStructs: Array = []

## This function is called when upgrading
func onUpgrade() -> void:
	pass

## Use this to track upgrade statistics
func incrementUpgradeStat(increase: float) -> void:
	if upgradeIdentifier not in playerUpgrades.keys():
		playerUpgrades[upgradeIdentifier] = 0
	playerUpgrades[upgradeIdentifier] += increase

## Use this to track upgrade statistics if an upgrade alters a different upgrade
func incrementDifferentUpgradeStat(identifier: String, increase: float) -> void:
	if identifier not in playerUpgrades.keys():
		playerUpgrades[identifier] = 0
	playerUpgrades[identifier] += increase

func getUpgradeStruct() -> UpgradeStruct:
	var newStruct = UpgradeStruct.new()
	newStruct.rawDescription = accumativeDescription
	newStruct.texture = texture
	newStruct.identifier = upgradeIdentifier
	return newStruct

# this sets up all the upgrades found in res://Upgrades
static func _static_init() -> void:
	print("--- Setting up upgrades ---")
	var filePaths = DirAccess.get_files_at("res://Upgrades/")
	for filePath in filePaths:
		if filePath.ends_with(".tscn"):
			var upgradePath = "res://Upgrades/" + filePath
			var currentUpgrade: Upgrade = load(upgradePath).instantiate()
			var upgradeStruct = currentUpgrade.getUpgradeStruct()
			upgradeStructs.append(upgradeStruct)
			currentUpgrade.queue_free()
			print("Setup upgrade: " + filePath)
	print("--- Finished setting up upgrades ---")

static func getCurrentUpgradeStructs() -> Array:
	var currentStructs = []
	for upgrade: UpgradeStruct in upgradeStructs:
		if upgrade.identifier in playerUpgrades.keys():
			currentStructs.append(upgrade)
	return currentStructs

class UpgradeStruct:
	var rawDescription: String
	var texture: Texture2D
	var identifier: String
	func getDescription() -> String:
		var replacement = str(Upgrade.playerUpgrades[identifier])
		return rawDescription.replace("[amt]", replacement)
