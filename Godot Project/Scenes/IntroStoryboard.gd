extends CanvasLayer

# preload gpu particle effects to reduce lag during runtime
var preloadParticleInstances = [
	 preload("res://Particles/FallingLeaves.tres"),
	 preload("res://Particles/AbsorptionCenter.tres"),
	 preload("res://Particles/AbsorptionFromTree.tres"),
	 preload("res://Particles/AbsorptionFromGround.tres")
]
func preloadParticles() -> void:
	var particles = []
	for particle: ParticleProcessMaterial in preloadParticleInstances:
		var instance = GPUParticles2D.new()
		instance.process_material = particle
		instance.one_shot = true
		instance.modulate = Color.TRANSPARENT
		instance.emitting = true
		add_child(instance)
		particles.append(instance)
	await TimeManager.wait(1.0)
	for particle: GPUParticles2D in particles:
		particle.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$IntroAnimatic.hide()
	await get_tree().physics_frame
	preloadParticles()
	await TimeManager.wait(0.5)
	
	# Slide 1
	IntroAmbience.fadeIn(1.5)
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
	IntroAudioController.fadeIn("PortalAmbienceFar", 2.0, -10.0)
	TypewriterText.setText("But one day, a deep blue portal bursts open on a street.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	TypewriterText.setText("Some of the townsfolk stared while others were clever enough to stay away.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	
	# Slide 3
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide3.png"))
	StoryboardImage.fadeIn(1.0)
	IntroAmbience.changeVolume(2.0, -12)
	TypewriterText.setText("The town sheriff ran out into the street to observe the commotion.")
	await TimeManager.wait(0.5)
	IntroAudioController.fadeIn("Footstep", 0.0, -4.0)
	await TimeManager.wait(0.5)
	IntroAudioController.fadeIn("Footstep2", 0.0, -4.0)
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
	IntroAudioController.fadeOut("PortalAmbienceFar", 1.0)
	IntroAudioController.fadeIn("PortalAmbienceNear", 2.0, -9.0)
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide5.png"))
	StoryboardImage.fadeIn(1.0)
	TypewriterText.interval = 0.035
	TypewriterText.setDialogueType(TypewriterText.DialogueType.DEFAULT)
	TypewriterText.setText("As the sheriff slowly approaches the portal, it begins to get brighter.")
	IntroAmbience.fadeOut(4.0)
	await TypewriterText.finishedAnimation
	await TimeManager.wait(0.5)
	IntroAudioController.fadeIn("PortalExplosion", 0.0, -8.0)
	await TimeManager.wait(1.25)
	IntroAudioController.fadeOut("PortalAmbienceNear", 0.0)
	
	# Slide 6
	TypewriterText.setText("")
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide6.png"))
	StoryboardImage.flashColor(Color.WHITE, 2.25)
	StoryboardImage.shake()
	await TimeManager.wait(1.5)
	TypewriterText.setText("A powerful shockwave erupted from the portal, knocking everyone back and causing mass destruction.")
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
	IntroAudioController.fadeIn("PortalAmbienceNear", 1.0, -10.0)
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide8.png"))
	StoryboardImage.fadeIn(1.5)
	TypewriterText.setDialogueType(TypewriterText.DialogueType.DEFAULT)
	TypewriterText.interval = 0.035
	TypewriterText.setText("Something emerges from the portal...")
	await TimeManager.wait(1.0)
	IntroAudioController.fadeIn("WizardAppears", 0.0, -8.0)
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	
	# Slide 9
	IntroAudioController.fadeIn("WizardNoticed", 0.0, -6.0)
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide9.png"))
	StoryboardImage.fadeIn(2.5)
	TypewriterText.interval = 0.1
	TypewriterText.setText("The evil wizard.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.5)
	
	# Slide 10
	TypewriterText.interval = 0.035
	IntroAudioController.fadeOut("PortalAmbienceNear", 1.0)
	IntroAudioController.fadeIn("PortalAmbienceFar", 1.0, -10.0)
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide10.png"))
	StoryboardImage.fadeIn(1.0)
	TypewriterText.setText("The wizard slowly made his way to the sheriff.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	
	# Slide 11
	IntroAudioController.fadeOut("PortalAmbienceFar", 5.0)
	StoryboardImage.fadeOut(0.5)
	await TimeManager.wait(0.5)
	IntroAudioController.fadeIn("WizardNoticed", 0.0, -6.0)
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide11.png"))
	StoryboardImage.fadeIn(0.5)
	await TimeManager.wait(2.75)
	StoryboardImage.fadeOut(1.25)
	TypewriterText.fadeOut(1.25)
	await TimeManager.wait(1.35)
	
	# here, we can play a little animatic
	var animaticAnimationPlayer = $IntroAnimatic/AnimationPlayer
	animaticAnimationPlayer.play("animatic")
	$IntroAnimatic/WizardContainer/Wizard/AnimationPlayer.play("WizardIdle")
	$IntroAnimatic/WandContainer/AnimationPlayer.play("WandIdle")
	$IntroAnimatic/TreeContainer/RadialGradient/AnimationPlayer.play("Gradient")
	$IntroAnimatic/TreeContainer/TopRadialGradient/AnimationPlayer.play("Gradient")
	$IntroAnimatic/FlowerContainer/RadialGradient/AnimationPlayer.play("Gradient")
	if get_tree() == null:
		return
	await get_tree().physics_frame
	$IntroAnimatic.show()
	await TimeManager.wait(animaticAnimationPlayer.current_animation_length)
	$IntroAnimatic.hide()
	
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
	IntroAudioController.fadeIn("Bell", 0.0, -8.0)
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide13.png"))
	StoryboardImage.fadeIn(1.0)
	TypewriterText.setDialogueType(TypewriterText.DialogueType.DEFAULT)
	TypewriterText.interval = 0.035
	TypewriterText.setText("His wand has the power to control the element of water.")
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
	IntroAmbience.current.stream = preload("res://Scenes/Ambience.mp3")
	IntroAmbience.fadeIn(5.0)
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide14.png"))
	StoryboardImage.fadeIn(1.5)
	TypewriterText.setDialogueType(TypewriterText.DialogueType.DEFAULT)
	TypewriterText.setText("This once beautiful, lush, and prosperous town is now...   \nBarren.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	
	# Slide 15
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide15.png"))
	StoryboardImage.fadeIn(1.0)
	TypewriterText.setText("You come back to find your beloved town in shambles and you see the town sheriff, barely alive.")
	await TypewriterText.finishedAnimation
	await TimeManager.wait(3.0)
	
	# Slide 16
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide16.png"))
	StoryboardImage.fadeIn(0.5)
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
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide17.png"))
	StoryboardImage.fadeIn(1.0)
	TypewriterText.interval = 0.05
	TypewriterText.setDialogueType(TypewriterText.DialogueType.SHERIFF)
	TypewriterText.setText('"The wizard, son... He\'s back."')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(1.5)
	
	# Slide 18
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide18.png"))
	StoryboardImage.fadeIn(1.0)
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
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide19.png"))
	StoryboardImage.fadeIn(1.0)
	TypewriterText.interval = 0.035
	TypewriterText.setDialogueType(TypewriterText.DialogueType.PLAYER)
	TypewriterText.setText('"No! Don\'t leave us! We need you!"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(1.5)
	
	# Slide 20
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide20.png"))
	StoryboardImage.fadeIn(1.0)
	TypewriterText.interval = 0.06
	TypewriterText.setDialogueType(TypewriterText.DialogueType.SHERIFF)
	TypewriterText.setText('"I don\'t have much time left...    \nCan you promise me something son?"')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	
	# Slide 21
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide21.png"))
	StoryboardImage.fadeIn(0.5)
	TypewriterText.interval = 0.07
	TypewriterText.setDialogueType(TypewriterText.DialogueType.PLAYER)
	TypewriterText.setText('"Yes, dad..."')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(1.5)
	
	# Slide 22
	StoryboardImage.setTexture(preload("res://Scenes/Intro/Images/Slide22.png"))
	StoryboardImage.fadeIn(1.25)
	TypewriterText.interval = 0.125
	TypewriterText.setDialogueType(TypewriterText.DialogueType.SHERIFF)
	TypewriterText.setText('"Please, protect our village. \nWe can\'t lose anymore people."')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	
	TypewriterText.interval = 0.1
	TypewriterText.setDialogueType(TypewriterText.DialogueType.PLAYER)
	TypewriterText.setText('"I will, dad."')
	await TypewriterText.finishedAnimation
	await TimeManager.wait(2.0)
	IntroAmbience.fadeOut(2.5)
	StoryboardImage.fadeOut(2.5)
	TypewriterText.fadeOut(2.5)

	if get_tree() == null:
		return
	await TimeManager.wait(3.0)
	NodeRelations.loadScene("res://Scenes/Tutorial.tscn")
