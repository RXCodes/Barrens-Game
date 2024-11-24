class_name TimeManager extends Node
static var current: Node

# this class is used to creating delays between executions of code
# e.g., `await TimeManager.wait(0.5)` will wait 0.5s before running the next line

func _ready() -> void:
	current = self

## `await TimeManager.wait(0.5)` will wait 0.5s before running the next line
static func wait(seconds: float):
	if current.get_tree() == null:
		return
	return current.get_tree().create_timer(seconds).timeout

## `var timer = TimeManager.waitTimer` will allow you to access this timer using "timer"
static func waitTimer(seconds: float) -> SceneTreeTimer:
	if current.get_tree() == null:
		return
	return current.get_tree().create_timer(seconds)

## `await TimeManager.promise([signal1, signal2, signal3])'
## will wait until any one of the signals is called
static var currentPromises = []
static func promise(signals: Array, maxTime: float = INF) -> Signal:
	var newPromise = Promise.new()
	currentPromises.append(newPromise)
	newPromise.startWithSignals(signals, maxTime)
	return newPromise.once

## `await TimeManager.promiseAll([signal1, signal2, signal3])'
## will wait until all of the signals are called
static func promiseAll(signals: Array, maxTime: float = INF) -> Signal:
	var newPromise = Promise.new()
	currentPromises.append(newPromise)
	newPromise.startWithSignals(signals, maxTime)
	return newPromise.all

# class for handling awaiting multiple signals
class Promise:
	var emittedOnce = false
	signal once
	signal all
	var count = 0
	func startWithSignals(array: Array, maxTime: float = INF):
		count = array.size()
		for signalCall in array:
			wait(signalCall)
		if maxTime != INF:
			await TimeManager.wait(maxTime)
			once.emit()
			all.emit()
	
	func wait(forSignal: Signal):
		await forSignal
		count -= 1
		if not emittedOnce:
			emittedOnce = true
			once.emit()
		if count <= 0:
			all.emit()
			TimeManager.currentPromises.erase(self)
