extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().physics_frame
	await TimeManager.wait(0.5)
	
	# Slide 1
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide1.png"))
	StoryboardImage.fadeIn(1.0)
	await TimeManager.wait(3.0)
	TypewriterText.setText("This peaceful and prosperous town was full of proud hardworking people doing their daily chores.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	TypewriterText.setText("The townsfolk lived in harmony and were fulfilled with their daily work.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	
	# Slide 2
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide2.png"))
	StoryboardImage.fadeIn(1.0)
	TypewriterText.setText("But one day, a deep blue portal bursts open on a street.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	TypewriterText.setText("Some of the townsfolk stared while others were clever enough to stay away.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	
	# Slide 3
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide3.png"))
	StoryboardImage.fadeIn(1.0)
	TypewriterText.setText("The town sheriff ran out into the street to observe the commotion.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	
	# Slide 4
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide4.png"))
	StoryboardImage.fadeIn(0.5)
	TypewriterText.interval = 0.06
	TypewriterText.setDialogueType(TypewriterText.DialogueType.SHERIFF)
	TypewriterText.setText('"Okay, what\'s going on?"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.5)
	
	# Slide 5
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide5.png"))
	StoryboardImage.fadeIn(1.0)
	TypewriterText.interval = 0.035
	TypewriterText.setDialogueType(TypewriterText.DialogueType.DEFAULT)
	TypewriterText.setText("As the sheriff slowly approaches the portal, it begins to get brighter.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	
	# Slide 6
	TypewriterText.setText("")
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide6.png"))
	StoryboardImage.flashColor(Color.WHITE, 2.25)
	StoryboardImage.shake()
	await TimeManager.wait(1.5)
	TypewriterText.setText("A powerful shockwave erupted from the portal, knocking everyone back and causing destruction.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	
	# Slide 7
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide7.png"))
	StoryboardImage.fadeIn(1.0)
	TypewriterText.interval = 0.08
	TypewriterText.setDialogueType(TypewriterText.DialogueType.SHERIFF)
	TypewriterText.setText('"WHAT WAS THAT?"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	
	# Slide 8
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide8.png"))
	StoryboardImage.fadeIn(1.5)
	TypewriterText.setDialogueType(TypewriterText.DialogueType.DEFAULT)
	TypewriterText.interval = 0.035
	TypewriterText.setText("Something emerges from the portal...")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	
	# Slide 9
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide9.png"))
	StoryboardImage.fadeIn(2.5)
	TypewriterText.interval = 0.1
	TypewriterText.setText("The evil wizard.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.5)
	
	# Slide 10
	TypewriterText.interval = 0.035
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide10.png"))
	StoryboardImage.fadeIn(1.0)
	TypewriterText.setText("The wizard slowly made his way to the sheriff.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	
	# Slide 11
	StoryboardImage.fadeOut(0.5)
	await TimeManager.wait(0.5)
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide11.png"))
	StoryboardImage.fadeIn(0.5)
	await TimeManager.wait(2.75)
	StoryboardImage.fadeOut(1.25)
	TypewriterText.fadeOut(1.25)
	await TimeManager.wait(1.35)
	
	# here, we can play a little animatic
	
	# Slide 12
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide12.png"))
	StoryboardImage.fadeIn(0.5)
	TypewriterText.setDialogueType(TypewriterText.DialogueType.WIZARD)
	TypewriterText.setText('"MUAHAHAHAHA! This land will soon be mine!"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	
	# Slide 13
	StoryboardImage.fadeOut(1.0)
	TypewriterText.fadeOut(1.0)
	await TimeManager.wait(1.0)
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide13.png"))
	StoryboardImage.fadeIn(1.0)
	TypewriterText.setDialogueType(TypewriterText.DialogueType.DEFAULT)
	TypewriterText.interval = 0.035
	TypewriterText.setText("His wand had the power to control the element of water.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	TypewriterText.setText("Legends say that its energy comes from absorbing large amounts of water.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	TypewriterText.setText("And with enough power, it could have the capability to destroy entire civilizations.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	StoryboardImage.fadeOut(1.0)
	TypewriterText.fadeOut(1.0)
	await TimeManager.wait(1.0)
	
	# Slide 14
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide14.png"))
	StoryboardImage.fadeIn(1.5)
	TypewriterText.setDialogueType(TypewriterText.DialogueType.DEFAULT)
	TypewriterText.setText("This once beautiful, lush, and properous town is now...   \nBarren.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	
	# Slide 15
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide15.png"))
	StoryboardImage.fadeIn(1.0)
	TypewriterText.setText("You come back to find your beloved town in shambles and you see the town sheriff, barely alive.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	
	# Slide 16
	TypewriterText.interval = 0.045
	TypewriterText.setDialogueType(TypewriterText.DialogueType.PLAYER)
	TypewriterText.setText('"NO! DAD! Please stay with me!"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(1.5)
	TypewriterText.interval = 0.035
	TypewriterText.setText('"Who did this to you? What happened here?"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(1.25)
	
	# Slide 17
	TypewriterText.interval = 0.05
	TypewriterText.setDialogueType(TypewriterText.DialogueType.SHERIFF)
	TypewriterText.setText('"The wizard, son... He\'s back."')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(1.5)
	
	# Slide 18
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
	
	# Slide 19
	TypewriterText.interval = 0.035
	TypewriterText.setDialogueType(TypewriterText.DialogueType.PLAYER)
	TypewriterText.setText('"No! Don\'t leave us! We need you!"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(1.5)
	
	# Slide 20
	TypewriterText.interval = 0.06
	TypewriterText.setDialogueType(TypewriterText.DialogueType.SHERIFF)
	TypewriterText.setText('"I don\'t have much time left...    \nCan you promise me something son?"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	
	# Slide 21
	TypewriterText.interval = 0.07
	TypewriterText.setDialogueType(TypewriterText.DialogueType.PLAYER)
	TypewriterText.setText('"Yes, dad..."')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(1.5)
	
	# Slide 22
	TypewriterText.interval = 0.1
	TypewriterText.setDialogueType(TypewriterText.DialogueType.SHERIFF)
	TypewriterText.setText('"Please, protect our village. \nWe can\'t lose it."')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	
	# Slide 23
	TypewriterText.interval = 0.09
	TypewriterText.setDialogueType(TypewriterText.DialogueType.PLAYER)
	TypewriterText.setText('"I will, dad."')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	StoryboardImage.fadeOut(2.5)
	TypewriterText.fadeOut(2.5)
