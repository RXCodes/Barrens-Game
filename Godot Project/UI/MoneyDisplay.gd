class_name MoneyDisplay extends Sprite2D

static var current: Sprite2D
static var moneyAmount: Label
static var currentTween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	moneyAmount = $MoneyAmount

static func setMoney(newAmount: int) -> void:
	moneyAmount.text = str(newAmount)
	current.scale = Vector2(1.35, 1.35)
	if currentTween:
		currentTween.stop()
	currentTween = NodeRelations.createTween()
	currentTween.set_ease(Tween.EASE_OUT)
	currentTween.set_trans(Tween.TRANS_ELASTIC)
	currentTween.tween_property(current, "scale", Vector2(1.25, 1.25), 0.75)
