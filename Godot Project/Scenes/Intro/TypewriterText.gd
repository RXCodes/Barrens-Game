class_name TypewriterText extends Label

static var current: Label
static var interval: float = 0.035
static var finishedAnimation: Signal

signal finishedAnimationRemote

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	current.text = ""
	finishedAnimation = finishedAnimationRemote

static func setText(text: String) -> void:
	current.text = text
	for i in range(text.length()):
		current.visible_characters = i
		
		# brief pauses on some characters
		if i > 0:
			var currentCharacter = text[i - 1]
			var nextCharacter = text[i]
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
	current.visible_ratio = 1.0
	finishedAnimation.emit()

static func fadeOut(duration: float) -> void:
	var tween = NodeRelations.createTween()
	tween.tween_property(current, "self_modulate", Color.BLACK, duration)

static func setColor(color: Color) -> void:
	current.self_modulate = color
