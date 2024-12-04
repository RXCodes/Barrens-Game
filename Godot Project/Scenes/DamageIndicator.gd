class_name DamageIndicator extends Label

static var damageIndicator = preload("res://UI/DamageIndicator.tscn")
static func createDamageIndicator(position: Vector2, amount: int, originNode: Node2D, criticalHit: bool = false) -> Node2D:
	var newIndicator: Node2D = damageIndicator.instantiate()
	var indicatorLabel: DamageIndicator = newIndicator.find_child("DamageIndicator")
	indicatorLabel.criticalHit = criticalHit
	indicatorLabel.text = str(amount)
	indicatorLabel.originNode = originNode
	newIndicator.global_position = position
	newIndicator.z_index = 4000
	if criticalHit:
		indicatorLabel.knockbackMultiplier += 0.25
	if amount >= 100:
		indicatorLabel.knockbackMultiplier += min((amount - 100) * 0.025, 1.5)
	NodeRelations.rootNode.add_child(newIndicator)
	return newIndicator

# Called when the node enters the scene tree for the first time.
var criticalHit = false
var originNode: Node2D
var knockbackMultiplier = 1.0
func _ready() -> void:
	var finalScale = Vector2(1.35, 1.35)
	if criticalHit:
		delayDuration = 2.5
		z_index = 99
		scale = Vector2(6, 10)
		finalScale = Vector2(1.65, 1.55)
		self_modulate = Color.GOLD
		CriticalHitParticles.createParticles(get_parent().global_position)
	else:
		scale = Vector2(3.25, 3.25)
	var tween = NodeRelations.createTween()
	tween.set_parallel()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", finalScale, 0.4)
	var directionVector = originNode.global_position.direction_to(get_parent().global_position)
	directionVector.rotated(randfn(0, 2))
	var newPosition = position + (directionVector * randfn(65, 10))
	tween.tween_property(self, "position", newPosition, 1)
	tween.tween_callback(scaled)

var delayDuration = 0.5
func scaled() -> void:
	await TimeManager.wait(delayDuration)
	var tween = NodeRelations.createTween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
	tween.tween_callback(get_parent().queue_free)
