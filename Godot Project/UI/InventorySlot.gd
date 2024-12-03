class_name InventorySlot extends Sprite2D

var index: int = 0
var itemEntity: Item.Entity

func setupSlot(index: int) -> void:
	$Key.text = str(index)
	self.index = index
	clearSlot()

func clearSlot() -> void:
	$Key.scale = Vector2(0.4, 0.4)
	$Amount.hide()
	$Item.hide()

func setItemCount(count: int) -> void:
	$Amount.text = str(count)
	$Amount.visible = count > 1
	$Key.scale = Vector2(0.275, 0.275)
	if count == 0:
		clearSlot()

func setupWithItemEntity(entity: Item.Entity) -> void:
	if entity == null:
		clearSlot()
		return
	setItemCount(entity.amount)
	$Item.show()
	$Item.texture = entity.itemTexture
	$Item.offset = entity.itemOffset

func select() -> void:
	texture = preload("res://UI/SelectedInventorySlot.png")

func deselect() -> void:
	texture = preload("res://UI/InventorySlot.png")
