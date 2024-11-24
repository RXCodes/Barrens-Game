class_name PlayerHealthBar extends Sprite2D

static var current: Sprite2D
static var progressBar: TextureProgressBar
static var progressBarUnder: TextureProgressBar
static var progress = 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progressBar = $ProgressBarUnder/ProgressBar
	progressBarUnder = $ProgressBarUnder
	progress = 100.0

var healthBarDampingMultiplier = 0.075
func _process(delta: float) -> void:
	progressBar.value = progress
	var difference = progress - progressBarUnder.value
	progressBarUnder.value += difference * healthBarDampingMultiplier

static func setProgress(newProgress: float) -> void:
	progress = newProgress
