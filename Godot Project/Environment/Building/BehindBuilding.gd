class_name StructureVisibilityManager extends Area2D

func _ready() -> void:
	renderer = get_parent()
	mouse_entered.connect(mouseEntered)
	mouse_exited.connect(mouseExited)

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player:
		playerIn = true

func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player:
		playerIn = false

var currentTween: Tween
var renderer: Node
var transparent = false
var playerIn = false:
	set(newValue):
		playerIn = newValue
		update()
var mouseIn = false:
	set(newValue):
		mouseIn = newValue
		update()

func fadeIn() -> void:
	if not transparent:
		return
	transparent = false
	if currentTween:
		currentTween.stop()
	currentTween = NodeRelations.createTween()
	currentTween.tween_property(renderer, "self_modulate", Color.WHITE, 1)
	
func fadeOut() -> void:
	if transparent:
		return
	transparent = true
	if currentTween:
		currentTween.stop()
	currentTween = NodeRelations.createTween()
	currentTween.tween_property(renderer, "self_modulate", Color(1, 1, 1, 0.5), 0.25)

func _process(delta: float) -> void:
	if mouseIn:
		update()

func update() -> void:
	if playerIn:
		return fadeOut()
	if mouseIn:
		# the player must be above the structure's position to see what's behind it
		var collision: CollisionShape2D = get_child(0)
		var shape: RectangleShape2D = collision.shape
		var yPosition = collision.global_position.y + ((collision.global_scale.y * shape.size.y) / 2.0)
		if Player.current.global_position.y <= yPosition:
			return fadeOut()
	fadeIn()

func mouseEntered() -> void:
	mouseIn = true

func mouseExited() -> void:
	mouseIn = false
