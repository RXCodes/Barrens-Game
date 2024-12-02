extends Area2D

func _ready() -> void:
	renderer = get_parent()

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player or body.get_meta(EnemyAI.parentControllerKey) is EnemyAI:
		currentShapesCount += 1
		if currentShapesCount == 1:
			fadeOut()

func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player or body.get_meta(EnemyAI.parentControllerKey) is EnemyAI:
		currentShapesCount -= 1
		if currentShapesCount == 0:
			fadeIn()

var currentTween: Tween
var renderer: Node
var currentShapesCount = 0

func fadeIn() -> void:
	if currentTween:
		currentTween.stop()
	currentTween = NodeRelations.createTween()
	currentTween.tween_property(renderer, "self_modulate", Color.WHITE, 1)
	
func fadeOut() -> void:
	if currentTween:
		currentTween.stop()
	currentTween = NodeRelations.createTween()
	currentTween.tween_property(renderer, "self_modulate", Color(1, 1, 1, 0.5), 0.25)
