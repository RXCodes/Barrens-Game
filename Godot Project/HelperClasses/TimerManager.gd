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

## `await TimeManager.promise([signal1, signal2, signal3])'
## will wait until any one of the signals is called
static var currentPromises = []
static func promise(signals: Array) -> Signal:
	var newPromise = Promise.new()
	currentPromises.append(newPromise)
	newPromise.startWithSignals(signals)
	return newPromise.done

class Promise:
	var emitted = false
	signal done
	var count = 0
	func startWithSignals(array: Array):
		count = array.size()
		for signalCall in array:
			wait(signalCall)
	
	func wait(forSignal: Signal):
		await forSignal
		count -= 1
		if not emitted:
			emitted = true
			done.emit()
		if count <= 0:
			TimeManager.currentPromises.erase(self)
