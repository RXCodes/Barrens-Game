class_name WaveDisplay extends Node2D

static var current: WaveDisplay
static var waveCount: Label
static var seconds: Label
static var waveStartingNode: Node2D
static var waveStartingAudioStreamPlayer: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	waveStartingNode = $WaveStarting
	waveCount = $WaveStarting/WaveCount
	seconds = $WaveStarting/Seconds
	waveStartingAudioStreamPlayer = $WaveStarting/AudioStreamPlayer
	waveStartingNode.hide()

static func start(waveNumber: int, countdownSeconds: int) -> void:
	# animate in
	waveStartingNode.show()
	waveStartingNode.modulate = Color.TRANSPARENT
	waveStartingNode.scale = Vector2(0.75, 0.75)
	waveStartingAudioStreamPlayer.play()
	waveCount.text = "Wave " + str(waveNumber)
	var tween = NodeRelations.createTween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(waveStartingNode, "modulate", Color.WHITE, 1.0)
	tween.parallel().tween_property(waveStartingNode, "scale", Vector2.ONE, 1.0)
	
	# perform a countdown
	while countdownSeconds > 0:
		seconds.text = str(countdownSeconds)
		await TimeManager.wait(1.0)
		countdownSeconds -= 1
	
	# countdown has ended - fade out
	seconds.text = "0"
	await TimeManager.wait(1.5)
	var fadeOut = NodeRelations.createTween()
	fadeOut.set_ease(Tween.EASE_OUT)
	fadeOut.set_trans(Tween.TRANS_EXPO)
	fadeOut.tween_property(waveStartingNode, "modulate", Color.TRANSPARENT, 1.0)
	fadeOut.parallel().tween_property(waveStartingNode, "scale", Vector2(0.75, 0.75), 1.0)
	
	# after a delay, hide the element
	await TimeManager.wait(1.1)
	waveStartingNode.hide()
