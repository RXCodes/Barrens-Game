class_name WaveInfoDisplay extends Node2D

static var current: WaveInfoDisplay
static var enemiesIcon: Sprite2D
static var waveIcon: Sprite2D
static var enemyCount: Label
static var waveCount: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	enemiesIcon = $Enemies
	waveIcon = $Wave
	enemyCount = $Enemies/Amount
	waveCount = $Wave/Amount
	hide()

static func revealDisplay() -> void:
	current.show()
	current.modulate = Color.TRANSPARENT
	var fadeIn = NodeRelations.createTween()
	fadeIn.tween_property(current, "modulate", Color.WHITE, 1.0)

static var enemyUpdateTween: Tween
static func setEnemyCount(count: int, animated: bool = true) -> void:
	enemyCount.text = str(count)
	if animated:
		enemiesIcon.scale = Vector2(3.0, 3.0)
		if enemyUpdateTween:
			enemyUpdateTween.stop()
		enemyUpdateTween = NodeRelations.createTween()
		enemyUpdateTween.set_ease(Tween.EASE_OUT)
		enemyUpdateTween.set_trans(Tween.TRANS_ELASTIC)
		enemyUpdateTween.tween_property(enemiesIcon, "scale", Vector2(2.5, 2.5), 0.8)

static var waveUpdateTween: Tween
static func setCurrentWave(wave: int, animated: bool = true) -> void:
	waveCount.text = str(wave)
	if animated:
		waveIcon.scale = Vector2(3.0, 3.0)
		if waveUpdateTween:
			waveUpdateTween.stop()
		waveUpdateTween = NodeRelations.createTween()
		waveUpdateTween.set_ease(Tween.EASE_OUT)
		waveUpdateTween.set_trans(Tween.TRANS_ELASTIC)
		waveUpdateTween.tween_property(waveIcon, "scale", Vector2(2.5, 2.5), 0.8)
