extends TextureButton

var exited = false

func _on_pressed() -> void:
	if exited:
		return
	exited = true
	var shouldOpenDeathScreen = GamePopup.current.data.get("deathScreen", false)
	if shouldOpenDeathScreen:
		GamePopup.openPopup("DeathScreen")
	else:
		GamePopup.closeCurrent()
