extends Node2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
var activated = false
func _process(delta: float) -> void:
	if not activated:
		if Player.current.global_position.distance_squared_to(global_position) > 600:
			return
		NodeRelations.loadScene("res://Scenes/Village1.tscn")
		activated = true
