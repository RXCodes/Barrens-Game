extends Node

# this is where the game actually happens (waves, enemy spawning, etc.)

func _ready() -> void:
	# first fade in
	var fadeIn = $"../ScreenUI/FadeIn"
	fadeIn.scale = Vector2(1000, 1000)
	await get_tree().physics_frame
	await TimeManager.wait(0.5)
	TutorialManager.shouldDisableControls = false
	var fadeInTween = NodeRelations.createTween()
	fadeInTween.tween_property(fadeIn, "self_modulate", Color(0, 0, 0, 0), 4.0)

	# here we can start waves
	await TimeManager.wait(5.0)
	print("Starting!")
	
