class_name DamageIndicator extends Label

static var damageIndicator = preload("res://UI/DamageIndicator.tscn")
static func createDamageIndicator(position: Vector2, amount: int, originNode: Node2D) -> void:
	var newIndicator: Node2D = damageIndicator.instantiate()
	var indicatorLabel: Label = newIndicator.find_child("DamageIndicator")
	indicatorLabel.text = str(amount)
	indicatorLabel.originNode = originNode
	newIndicator.global_position = position
	newIndicator.z_index = 4000
	NodeRelations.rootNode.add_child(newIndicator)

# Called when the node enters the scene tree for the first time.
var originNode: Node2D
func _ready() -> void:
	scale = Vector2(2, 2)
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2.ONE, 0.4)
	var directionVector = originNode.global_position.direction_to(global_position)
	directionVector.rotated(randfn(0, 2))
	var newPosition = position + (directionVector * randfn(45, 5))
	tween.tween_property(self, "position", newPosition, 1)
	tween.tween_callback(scaled)

func scaled() -> void:
	await TimeManager.wait(0.5)
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
	tween.tween_callback(get_parent().queue_free)
