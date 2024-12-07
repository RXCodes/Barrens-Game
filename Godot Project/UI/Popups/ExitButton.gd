extends TextureButton

var exited = false
var isReady = false

func _ready() -> void:
	await TimeManager.wait(0.1)
	isReady = true

func _on_pressed() -> void:
	if exited or not isReady:
		return
	exited = true
	var shouldOpenDeathScreen = GamePopup.current.data.get("deathScreen", false)
	if shouldOpenDeathScreen:
		GamePopup.openPopup("DeathScreen")
	else:
		GamePopup.closeCurrent()
