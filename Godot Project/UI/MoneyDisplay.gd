class_name MoneyDisplay extends Sprite2D

static var current: Sprite2D
static var moneyAmount: Label
static var currentTween: Tween
static var initialPosition: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	moneyAmount = $MoneyAmount
	initialPosition = position

static func setMoney(newAmount: int) -> void:
	moneyAmount.text = str(newAmount)
	current.scale = Vector2(1.35, 1.35)
	if currentTween:
		currentTween.stop()
	currentTween = NodeRelations.createTween()
	currentTween.set_ease(Tween.EASE_OUT)
	currentTween.set_trans(Tween.TRANS_ELASTIC)
	currentTween.tween_property(current, "scale", Vector2(1.25, 1.25), 0.75)

# error plays when failed purchase
static var errorTween: Tween
static func error() -> void:
	if errorTween:
		errorTween.stop()
	current.position.y = initialPosition.y + 12.5
	moneyAmount.self_modulate = Color.RED
	errorTween = NodeRelations.createTween()
	errorTween.set_ease(Tween.EASE_OUT)
	errorTween.set_trans(Tween.TRANS_ELASTIC)
	errorTween.tween_property(moneyAmount, "self_modulate", Color.WHITE, 1.2)
	errorTween.parallel().tween_property(current, "position", initialPosition, 1.2)
