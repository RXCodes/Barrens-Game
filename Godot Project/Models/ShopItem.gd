class_name ShopItem extends Node

@export var displayName: String
@export var displayTexture: Texture2D
@export var displayTextureOffset: Vector2 = Vector2.ZERO
@export var displayScale: float = 1.0
@export var price: int
@export var description: String
@export var amount: int = 1

enum ItemType {GUN, ITEM, UPGRADE}
@export var type: ItemType

## e.g., "Shotgun", "MachineGun" for GUN item type
@export var itemIdentifier: String

@export var limitSales: bool = false
@export var limitAmount: int = 10
@export var canRestock: bool = false
@export var restockTime: int = 60
@export var restockAmount: int = 10

var itemsLeft: int = INF

func _ready() -> void:
	if limitSales:
		itemsLeft = limitAmount
