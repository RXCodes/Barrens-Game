class_name Shop extends Area2D

var shopItems: Array = []

func _ready() -> void:
	interactNode = $"../Interact"
	interactNode.modulate = Color.TRANSPARENT
	var children = get_parent().get_children()
	for node in children:
		if node is ShopItem:
			shopItems.append(node)

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player:
		fadeIn()

func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player:
		fadeOut()

var currentTween: Tween
var interactNode: Node
var canAccessShop = false

func fadeIn() -> void:
	if currentTween:
		currentTween.stop()
	currentTween = NodeRelations.createTween()
	currentTween.tween_property(interactNode, "modulate", Color.WHITE, 0.15)
	canAccessShop = true
	
func fadeOut() -> void:
	if currentTween:
		currentTween.stop()
	currentTween = NodeRelations.createTween()  
	currentTween.tween_property(interactNode, "modulate", Color.TRANSPARENT, 0.15)
	canAccessShop = false

func _input(event: InputEvent) -> void:
	if GamePopup.current:
		return
	if not event.is_pressed():
		return
	if not canAccessShop:
		return
	if event is InputEventKey:
		var key: String = event.as_text_key_label()
		if key == "E":
			GamePopup.openPopup("Shop", {
				"shopItems": shopItems
			})
