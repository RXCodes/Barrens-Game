class_name EnemyHealthBar extends TextureProgressBar

var progress: float = 100.0
var progressBar: TextureProgressBar
var enemyDead = false
func _enter_tree() -> void:
	progressBar = $ProgressBar

var healthBarDampingMultiplier = 0.1
func _process(delta: float) -> void:
	progressBar.value = progress + 2.0
	var difference = progress - self.value
	self.value += difference * healthBarDampingMultiplier
	if progress <= 0:
		enemyDied()
	
func enemyDied() -> void:
	if enemyDead:
		return
	enemyDead = true
	
	# when enemy dies, fade to transparent after a short delay
	await TimeManager.wait(0.6)
	var tween = NodeRelations.createTween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.15)

func setHealthBarColor(newColor: Color) -> void:
	progressBar.tint_progress = newColor
