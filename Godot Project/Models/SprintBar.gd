class_name SprintBar extends TextureProgressBar

var currentTween: Tween
var flashing = false

func fadeIn() -> void:
	if currentTween:
		currentTween.stop()
	currentTween = NodeRelations.createTween()
	currentTween.tween_property(self, "modulate", Color.WHITE, 0.1)
	
func fadeOut() -> void:
	if currentTween:
		currentTween.stop()
	currentTween = NodeRelations.createTween()
	currentTween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)

func startFlashing() -> void:
	if flashing:
		return
	flashing = true
	while flashing:
		modulate = Color(1.0, 1.0, 1.0, 0.2)
		await TimeManager.wait(0.15)
		modulate = Color.WHITE
		await TimeManager.wait(0.15)
	
func stopFlashing() -> void:
	flashing = false
