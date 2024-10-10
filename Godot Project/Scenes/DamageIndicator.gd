class_name DamageIndicator extends Label

static var damageIndicator = preload("res://UI/DamageIndicator.tscn")
static func createDamageIndicator(position: Vector2, amount: int) -> void:
	var newIndicator: RigidBody2D = damageIndicator.instantiate()
	var indicatorLabel: Label = newIndicator.find_child("DamageIndicator")
	indicatorLabel.text = str(amount)
	newIndicator.global_position = position
	NodeRelations.rootNode.find_child("Level").add_child(newIndicator)
	newIndicator.set_meta(ZIndexSorter.zScoreKey, INF)

# Called when the node enters the scene tree for the first time.
var shape: Node
func _ready() -> void:
	scale = Vector2(2, 2)
	shape = $"../Shape"
	shape.scale = Vector2.ZERO
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2.ONE, 0.4)
	var newPosition = position + Vector2(0, -20)
	tween.tween_property(self, "position", newPosition, 0.4)
	tween.tween_property(shape, "scale", Vector2.ONE, 0.6)
	tween.tween_callback(scaled)

func scaled() -> void:
	await TimeManager.wait(0.7)
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
	tween.tween_callback(get_parent().queue_free)
