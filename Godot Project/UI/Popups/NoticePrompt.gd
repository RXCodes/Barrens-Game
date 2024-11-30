class_name NoticePrompt extends NinePatchRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var data = GamePopup.current.data
	$Title.text = data["title"]
	$Description.text = data["description"]
	$"../Okay/Text".text = data["okayText"]
