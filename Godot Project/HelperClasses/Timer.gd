class_name TimeManager extends Node
static var current: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self

static func wait(seconds: float):
	return current.get_tree().create_timer(seconds).timeout

static func waitTimer(seconds: float) -> SceneTreeTimer:
	return current.get_tree().create_timer(seconds)
