class_name ShopItem extends Node

## the display name to show in the shop
@export var displayName: String

## the texture to display in the shop
@export var displayTexture: Texture2D

## the offset of the displayed texture
@export var displayTextureOffset: Vector2 = Vector2.ZERO

## the scale multiplier for the texture
@export var displayScale: float = 1.0

## the price of the item
@export var price: int

## the description to show
@export var description: String

## how many items to sell per purchase
@export var amount: int = 1

enum ItemType {GUN, ITEM, UPGRADE}
@export var type: ItemType

## e.g., "Shotgun", "MachineGun" for GUN item type
## - "AmmoPickup" for ITEM type
@export var itemIdentifier: String

## if enabled, you can limit the amount of purchases to the item
@export var limitSales: bool = false

## the limited amount of purchases (limitSales must be enabled)
@export var limitAmount: int = 10

## if enabled, the items can restock when stock is empty
@export var canRestock: bool = false

## how many seconds for the items to restock
@export var restockTime: int = 60

## after restocking, this is the amount of items that will be in stock
@export var restockAmount: int = 10

## how much to increase (or decrease) the price for each purchase - used mainly for upgrades
@export var costIncrementMultiplier: float = 1.0

var itemsLeft: int = INF
var restocking: bool = false
var shopInteractor: ShopInteractor

func _ready() -> void:
	if limitSales:
		itemsLeft = limitAmount

func purchasedItem() -> void:
	if limitSales:
		itemsLeft -= 1
		if itemsLeft == 0:
			restocking = true
			await TimeManager.wait(restockTime)
			restocking = false
			itemsLeft = restockAmount
			if is_instance_valid(shopInteractor):
				shopInteractor.refreshShopItems()
	price = round(price * costIncrementMultiplier)
