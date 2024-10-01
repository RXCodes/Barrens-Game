class_name TimeManager extends Node
static var current: Node

# this class is used to creating delays between executions of code
# e.g., `await TimeManager.wait(0.5)` will wait 0.5s before running the next line

func _ready() -> void:
	current = self

## `await TimeManager.wait(0.5)` will wait 0.5s before running the next line
static func wait(seconds: float):
	return current.get_tree().create_timer(seconds).timeout

## `var timer = TimeManager.waitTimer` will allow you to access this timer using "timer"
static func waitTimer(seconds: float) -> SceneTreeTimer:
	return current.get_tree().create_timer(seconds)
