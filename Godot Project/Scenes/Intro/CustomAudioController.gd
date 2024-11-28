class_name IntroAudioController extends Node

static var current: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self

static var quietDB = -35.0

static func changeVolume(name: String, time: float, targetDB: float) -> void:
	var target = current.find_child(name)
	if target == null:
		return
	var tween = NodeRelations.createTween()
	tween.tween_property(target, "volume_db", targetDB, time)
	if not target.playing:
		target.play()

static func fadeIn(name: String, time: float, targetDB: float) -> void:
	var target = current.find_child(name)
	if target == null:
		return
	target.volume_db = quietDB
	var tween = NodeRelations.createTween()
	tween.tween_property(target, "volume_db", targetDB, time)
	if not target.playing:
		target.play()

static func fadeOut(name: String, time: float) -> void:
	var target = current.find_child(name)
	if target == null:
		return
	var tween = NodeRelations.createTween()
	tween.tween_property(target, "volume_db", quietDB, time)
	tween.tween_callback(target.stop)
