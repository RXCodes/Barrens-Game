extends Label

var canSkip = false
var holdingSkip = false
var holdProgress = 0.0
var timeToHold = 1.5
var fadeOutTime = 16.0
var currentFadeTween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self_modulate = Color.TRANSPARENT
	await get_tree().physics_frame
	await TimeManager.wait(2.0)
	print("Display skip button")
	show()
	canSkip = true
	var tween = NodeRelations.createTween()
	tween.tween_property(self, "self_modulate", Color.WEB_GRAY, 1.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fadeOutTime > 0:
		fadeOutTime -= delta
		if fadeOutTime <= 0:
			var tween = NodeRelations.createTween()
			tween.tween_property(self, "self_modulate", Color.TRANSPARENT, 2.0)
	
	if holdingSkip and canSkip:
		holdProgress += delta / timeToHold
		if holdProgress >= 1.0:
			canSkip = false
			$"../Click".play()
			$"../Storyboard".queue_free()
			$SkipProgress.hide()
			text = "Intro has been skipped!"
			await TimeManager.wait(0.5)
			var tween = NodeRelations.createTween()
			tween.tween_property(self, "self_modulate", Color.TRANSPARENT, 1.0)
			await TimeManager.wait(1.2)
			NodeRelations.loadScene("res://Scenes/TitleScreen.tscn")
	else:
		holdProgress = 0.0
	$SkipProgress.scale.x = holdProgress

func _input(event: InputEvent) -> void:
	if event.as_text() != "Space":
		return
	holdingSkip = event.is_pressed()
	if holdingSkip and canSkip:
		fadeOutTime = maxf(fadeOutTime, 5.0)
		if currentFadeTween != null:
			currentFadeTween.stop()
		self_modulate = Color.WEB_GRAY
