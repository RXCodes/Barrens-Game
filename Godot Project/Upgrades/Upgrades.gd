class_name Upgrade extends Node

## display name of the upgrade
@export var upgradeName: String

## the description to display - doesn't effect what is shown in the shop
@export var description: String

## accumative description to use when player views their upgrades
## - [amt] will be replaced with the current statistic
@export var accumativeDescription: String

## an array of preferred numbers that the upgrade should use
## - this is used when randomly selecting upgrades or when an upgrade amount is not specified
@export var preferredUpgradeAmounts: Array[float]

## what identifier this upgrade uses
@export var upgradeIdentifier: String

## the texture this upgrade uses
@export var texture: Texture2D

## can this effect stack? if not, it can only be received once
@export var stackable: bool = true

## the minimum number in which these amounts are multiplied when the upgrade is randomly drawn
@export var minRandomUpgradeAmountMultiplier: float = 0.5

## the maximum number which these amounts are multiplied when the upgrade is randomly drawn
@export var maxRandomUpgradeAmountMultiplier: float = 4.0

static var playerUpgrades: Dictionary = {}
static var upgradeStructs: Array = []

## This function is called when upgrading (override this)
func onUpgrade(amounts: Array) -> void:
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

func getDescription(amounts: Array) -> String:
	var outputDescription = description
	for i in range(amounts.size()):
		var index = i + 1
		if index == 1:
			outputDescription = outputDescription.replace("[amt]", str(amounts[0]))
		else:
			outputDescription = outputDescription.replace("[amt" + str(index) + "]", str(amounts[i]))
	return outputDescription

# this sets up all the upgrades found in res://Upgrades
static var upgradeNames = []
static func _static_init() -> void:
	print("--- Setting up upgrades ---")
	var filePaths = []
	var directory = DirAccess.open("res://Upgrades/")
	if directory:
		directory.list_dir_begin()
		var fileName = directory.get_next()
		while fileName != "":
			if not directory.current_is_dir():
				print("Found file: " + fileName)
				filePaths.append(fileName)
			fileName = directory.get_next()
	else:
		print("An error occurred when trying to access upgrades folder")
	var loadedPaths = []
	for filePath in filePaths:
		if filePath.ends_with(".tscn"):
			var upgradePath = "res://Upgrades/" + filePath
			var currentUpgrade: Upgrade = ResourceLoader.load(upgradePath).instantiate()
			var upgradeStruct = currentUpgrade.getUpgradeStruct()
			var upgradeName = filePath.trim_suffix(".tscn")
			loadedPaths.append(upgradePath)
			upgradeStructs.append(upgradeStruct)
			upgradeNames.append(upgradeName)
			currentUpgrade.queue_free()
			print("Setup upgrade: " + filePath)
	
	print("--- Finished setting up upgrades ---")

static func pickRandomUpgrades(count: int) -> Array:
	var upgrades = []
	upgradeNames.shuffle()
	for i in range(count):
		var upgradeName = upgradeNames[i]
		upgrades.append(upgradeForName(upgradeName))
	return upgrades

static func upgradeForName(name: String) -> Upgrade:
	var path = "res://Upgrades/" + name + ".tscn"
	var upgrade = load(path).instantiate()
	return upgrade

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
		var newDescription = rawDescription.replace("[amt]", replacement)
		newDescription = newDescription.replace("+-", "-")
		newDescription = newDescription.replace("--", "+")
		return newDescription
	func isNegative() -> bool:
		return Upgrade.playerUpgrades[identifier] < 0
