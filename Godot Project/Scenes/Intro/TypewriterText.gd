class_name TypewriterText extends Label

static var current: Label
static var interval: float = 0.035
static var finishedAnimation: Signal
static var dialogueAudioPlayer: AudioStreamPlayer

signal finishedAnimationRemote

static var dialogueType: DialogueType = DialogueType.DEFAULT
enum DialogueType {DEFAULT, SHERIFF, PLAYER, WIZARD}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	current.text = ""
	finishedAnimation = finishedAnimationRemote
	dialogueAudioPlayer = $"../DialoguePlayer"

static func setText(text: String) -> void:
	current.text = text
	for i in range(text.length()):
		if not is_instance_valid(current):
			return
		current.visible_characters = i
		
		# play typewriter sound
		var currentCharacter = text[i - 1]
		var nextCharacter = text[i]
		if currentCharacter != ' ' and currentCharacter != '\n':
			dialogueAudioPlayer.play()
		
		# brief pauses on some characters
		if i > 0:
			if nextCharacter == ' ':
				if currentCharacter == '.':
					await TimeManager.wait(0.4)
				elif currentCharacter == ',':
					await TimeManager.wait(0.25)
				elif currentCharacter == '?':
					await TimeManager.wait(0.4)
				elif currentCharacter == '!':
					await TimeManager.wait(0.4)
		
		await TimeManager.wait(interval)
	
	# at this point, the typewriter has written the entire text
	current.visible_ratio = 1.0
	finishedAnimation.emit()

static func fadeOut(duration: float) -> void:
	var tween = NodeRelations.createTween()
	tween.tween_property(current, "self_modulate", Color.BLACK, duration)

static func setColor(color: Color) -> void:
	current.self_modulate = color

## change the sound playing for the typewriter and the text color
static func setDialogueType(type: DialogueType) -> void:
	dialogueType = type
	if type == DialogueType.DEFAULT:
		setColor(Color.WHITE)
		dialogueAudioPlayer.stream = preload("res://Scenes/Intro/Typewriter.mp3")
	elif type == DialogueType.SHERIFF:
		setColor(Color.DARK_SALMON)
		dialogueAudioPlayer.stream = preload("res://Scenes/Intro/SheriffTypewriter.mp3")
	elif type == DialogueType.PLAYER:
		setColor(Color.STEEL_BLUE)
		dialogueAudioPlayer.stream = preload("res://Scenes/Intro/PlayerTypewriter.mp3")
	elif type == DialogueType.WIZARD:
		setColor(Color.CRIMSON)
		dialogueAudioPlayer.stream = preload("res://Scenes/Intro/WizardTypewriter.mp3")
