extends Label

var canSkip = false
var holdingSkip = false
var holdProgress = 0.0
var timeToHold = 1.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self_modulate = Color.TRANSPARENT
	await get_tree().physics_frame
	await TimeManager.wait(2.0)
	print("Display skip button")
	canSkip = true
	var tween = NodeRelations.createTween()
	tween.tween_property(self, "self_modulate", Color.WHITE, 1.0)
	await TimeManager.wait(15.0)
	canSkip = false
	var tweenw = NodeRelations.createTween()
	tweenw.tween_property(self, "self_modulate", Color.TRANSPARENT, 2.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if holdingSkip and canSkip:
		holdProgress += delta / timeToHold
		if holdProgress >= 1.0:
			NodeRelations.loadScene("res://Scenes/Village1.tscn")
			canSkip = false
	else:
		holdProgress = 0.0
	$SkipProgress.scale.x = holdProgress

func _input(event: InputEvent) -> void:
	holdingSkip = event.is_pressed()
