extends Label

var canSkip = false
var holdingSkip = false
var holdProgress = 0.0
var timeToHold = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate = Color.TRANSPARENT
	await get_tree().physics_frame
	await TimeManager.wait(4.0)
	canSkip = true
	var tween = NodeRelations.createTween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.75)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if holdingSkip and canSkip:
		holdProgress += delta / timeToHold
		if holdProgress >= 1.0:
			canSkip = false
			GamePopup.closeCurrent()
	else:
		holdProgress = 0.0
	$SkipProgress.value = holdProgress * 100.0

func _input(event: InputEvent) -> void:
	if event.as_text() != "Space":
		return
	holdingSkip = event.is_pressed()
