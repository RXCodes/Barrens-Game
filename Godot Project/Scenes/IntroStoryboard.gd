extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().physics_frame
	await TimeManager.wait(0.5)
	StoryboardImage.fadeIn(1.0)
	await TimeManager.wait(3.0)
	TypewriterText.setText("This peaceful and prosperous town was full of proud hardworking people doing their daily chores.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	TypewriterText.setText("The townsfolk lived in harmony and were fulfilled with their daily work.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	TypewriterText.setText("But one day, a deep blue portal bursts open on a street.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	TypewriterText.setText("Some of the townsfolk stared while others were clever enough to stay away.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	TypewriterText.setText("The town sheriff ran out into the street to observe the commotion.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	TypewriterText.interval = 0.06
	TypewriterText.setDialogueType(TypewriterText.DialogueType.SHERIFF)
	TypewriterText.setText('"Okay, what\'s going on?"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	TypewriterText.interval = 0.035
	TypewriterText.setDialogueType(TypewriterText.DialogueType.DEFAULT)
	TypewriterText.setText("As the sheriff slowly approaches the portal, it begins to get brighter.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	TypewriterText.setText("A powerful shockwave eminated from the portal, knocking everyone back.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	TypewriterText.interval = 0.08
	TypewriterText.setDialogueType(TypewriterText.DialogueType.SHERIFF)
	TypewriterText.setText('"WHAT WAS THAT?"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	TypewriterText.setDialogueType(TypewriterText.DialogueType.DEFAULT)
	TypewriterText.interval = 0.035
	TypewriterText.setText("Something emerges from the portal.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	TypewriterText.interval = 0.06
	TypewriterText.setText("The evil wizard.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	TypewriterText.interval = 0.035
	TypewriterText.setText("The wizard slowly made his way to the sheriff.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	TypewriterText.setDialogueType(TypewriterText.DialogueType.WIZARD)
	TypewriterText.setText('"MUAHAHAHAHA! This land will now be mine!"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	TypewriterText.setDialogueType(TypewriterText.DialogueType.DEFAULT)
	TypewriterText.interval = 0.035
	TypewriterText.setText("His wand had the power to drain water from anything to use it for evil.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	TypewriterText.setText("This once beautiful, lush, and properous town is now...   \nBarren.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(4.0)
	TypewriterText.setText("You come back to find your beloved town in shambles and you see the town sheriff, barely alive.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	TypewriterText.interval = 0.045
	TypewriterText.setDialogueType(TypewriterText.DialogueType.PLAYER)
	TypewriterText.setText('"NO! DAD! Please stay with me!"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(1.5)
	TypewriterText.interval = 0.035
	TypewriterText.setText('"Who did this to you? What happened here?"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(1.25)
	TypewriterText.interval = 0.05
	TypewriterText.setDialogueType(TypewriterText.DialogueType.SHERIFF)
	TypewriterText.setText('"The wizard, son... He\'s back."')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(1.5)
	TypewriterText.interval = 0.035
	TypewriterText.setDialogueType(TypewriterText.DialogueType.PLAYER)
	TypewriterText.setText('"Impossible! I thought we defeated him a long time ago!"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(1.5)
	TypewriterText.interval = 0.05
	TypewriterText.setDialogueType(TypewriterText.DialogueType.SHERIFF)
	TypewriterText.setText('"I don\'t know... But he\'s much more powerful now and I don\'t think I can make it."')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(1.5)
	TypewriterText.interval = 0.035
	TypewriterText.setDialogueType(TypewriterText.DialogueType.PLAYER)
	TypewriterText.setText('"No! Don\'t leave us! We need you!"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(1.5)
	TypewriterText.interval = 0.06
	TypewriterText.setDialogueType(TypewriterText.DialogueType.SHERIFF)
	TypewriterText.setText('"I don\'t have much time left...    \nCan you promise me something son?"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	TypewriterText.interval = 0.07
	TypewriterText.setDialogueType(TypewriterText.DialogueType.PLAYER)
	TypewriterText.setText('"Yes, dad..."')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(1.5)
	TypewriterText.interval = 0.1
	TypewriterText.setDialogueType(TypewriterText.DialogueType.SHERIFF)
	TypewriterText.setText('"Please, protect our village. \nWe can\'t lose it."')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	TypewriterText.interval = 0.09
	TypewriterText.setDialogueType(TypewriterText.DialogueType.PLAYER)
	TypewriterText.setText('"I will, dad."')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	StoryboardImage.fadeOut(2.5)
	TypewriterText.fadeOut(2.5)
