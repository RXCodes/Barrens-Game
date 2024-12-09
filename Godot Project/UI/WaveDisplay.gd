class_name WaveDisplay extends Node2D

static var current: WaveDisplay
static var waveCount: Label
static var seconds: Label
static var waveCompletedDescription: Label
static var waveStartingNode: Node2D
static var waveStartedNode: Node2D
static var waveCompletedNode: Node2D
static var waveStartingAudioStreamPlayer: AudioStreamPlayer
static var waveCountdownAudioStreamPlayer: AudioStreamPlayer
static var waveStartedAudioStreamPlayer: AudioStreamPlayer
static var waveCompletedAudioStreamPlayer: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	waveStartingNode = $WaveStarting
	waveCount = $WaveStarting/WaveCount
	seconds = $WaveStarting/Seconds
	waveStartingAudioStreamPlayer = $WaveStarting/AudioStreamPlayer
	waveStartingNode.hide()
	waveStartedNode = $WaveStarted
	waveStartedNode.hide()
	waveStartedAudioStreamPlayer = $WaveStarted/AudioStreamPlayer
	waveCountdownAudioStreamPlayer = $WaveStarting/Countdown
	waveCompletedNode = $WaveCompleted
	waveCompletedDescription = $WaveCompleted/Description
	waveCompletedAudioStreamPlayer = $WaveCompleted/AudioStreamPlayer
	waveCompletedNode.hide()

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
		if countdownSeconds == 5:
			waveCountdownAudioStreamPlayer.play()
		if countdownSeconds <= 5:
			seconds.scale = Vector2(2.0, 2.0)
			seconds.self_modulate = Color.WHITE
			var countdownTween = NodeRelations.createTween()
			countdownTween.set_ease(Tween.EASE_OUT)
			countdownTween.set_trans(Tween.TRANS_ELASTIC)
			countdownTween.tween_property(seconds, "self_modulate", Color("f27b7d"), 1.0)
			countdownTween.parallel().tween_property(seconds, "scale", Vector2(1.5, 1.5), 1.0)
		await TimeManager.wait(1.0)
		countdownSeconds -= 1
	
	# countdown has ended - fade out
	waveStarted()
	seconds.text = "0"
	var fadeOut = NodeRelations.createTween()
	fadeOut.set_ease(Tween.EASE_OUT)
	fadeOut.set_trans(Tween.TRANS_EXPO)
	fadeOut.tween_property(waveStartingNode, "modulate", Color.TRANSPARENT, 1.0)
	fadeOut.parallel().tween_property(waveStartingNode, "scale", Vector2(0.75, 0.75), 1.0)
	
	# after a delay, hide the element
	await TimeManager.wait(1.1)
	waveStartingNode.hide()

static func waveStarted() -> void:
	# animate in
	waveStartedNode.show()
	waveStartedNode.modulate = Color.TRANSPARENT
	waveStartedNode.scale = Vector2(0.75, 0.75)
	waveStartedAudioStreamPlayer.play()
	var tween = NodeRelations.createTween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(waveStartedNode, "modulate", Color.WHITE, 1.0)
	tween.parallel().tween_property(waveStartedNode, "scale", Vector2.ONE, 1.0)
	
	await TimeManager.wait(4.5)
	var fadeOut = NodeRelations.createTween()
	fadeOut.set_ease(Tween.EASE_OUT)
	fadeOut.set_trans(Tween.TRANS_EXPO)
	fadeOut.tween_property(waveStartedNode, "modulate", Color.TRANSPARENT, 1.5)
	fadeOut.parallel().tween_property(waveStartedNode, "scale", Vector2(0.75, 0.75), 1.5)
	
	# after a delay, hide the element
	await TimeManager.wait(1.6)
	waveStartedNode.hide()

static func waveCompleted(earnings: int) -> void:
	# animate in
	waveCompletedNode.show()
	waveCompletedNode.modulate = Color.TRANSPARENT
	waveCompletedNode.scale = Vector2(0.75, 0.75)
	waveCompletedAudioStreamPlayer.play()
	waveCompletedDescription.text = "You earned " + str(earnings) + " cash!"
	
	var tween = NodeRelations.createTween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(waveCompletedNode, "modulate", Color.WHITE, 1.0)
	tween.parallel().tween_property(waveCompletedNode, "scale", Vector2.ONE, 1.0)
	
	await TimeManager.wait(3.0)
	var fadeOut = NodeRelations.createTween()
	fadeOut.set_ease(Tween.EASE_OUT)
	fadeOut.set_trans(Tween.TRANS_EXPO)
	fadeOut.tween_property(waveCompletedNode, "modulate", Color.TRANSPARENT, 1.0)
	fadeOut.parallel().tween_property(waveCompletedNode, "scale", Vector2(0.75, 0.75), 1.0)
	
	# after a delay, hide the element
	await TimeManager.wait(1.1)
	waveCompletedNode.hide()

# pauses the countdown
static func pause() -> void:
	if current:
		current.process_mode = Node.PROCESS_MODE_DISABLED

# resumes the countdown
static func unpause() -> void:
	if current:
		current.process_mode = Node.PROCESS_MODE_INHERIT
