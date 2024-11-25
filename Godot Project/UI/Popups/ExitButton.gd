extends TextureButton

var exited = false

func _on_pressed() -> void:
	if exited:
		return
	exited = true
	GamePopup.closeCurrent()
