class_name TitleScreenManager extends Node

static var canInteract = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if OS.has_feature("web"):
		$"../CanvasLayer/HeatEffect".queue_free()
	canInteract = false
	$"../CanvasLayer/Black".show()
	$"../Title".hide()
	$"../GameButtons".modulate = Color.TRANSPARENT
	await get_tree().physics_frame
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	await TimeManager.wait(1.0)
	$AudioStreamPlayer.play()
	await TimeManager.wait(0.2)
	$AnimationPlayer.play("TitleScreenOpening")
	await get_tree().physics_frame
	$"../Title".show()
	await TimeManager.wait(5.0)
	canInteract = true
	GamePopup.current = null
