class_name Upgrade extends Node

@export var upgradeName: String
@export var upgradeIdentifier: String
@export var texture: Texture2D
@export var usesPercentageUnits: bool = true

var baseAmount = 0.0
static var playerUpgrades: Dictionary = {}

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
