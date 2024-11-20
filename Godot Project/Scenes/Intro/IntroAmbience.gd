class_name IntroAmbience extends AudioStreamPlayer

static var current: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
	self.volume_db = quietDB

static var quietDB = -35.0
static var targetDB = -7.0

static func changeVolume(time: float, targetDB: float) -> void:
	var tween = NodeRelations.createTween()
	tween.tween_property(current, "volume_db", targetDB, time)
	if not current.playing:
		current.play()

static func fadeIn(time: float) -> void:
	var tween = NodeRelations.createTween()
	current.volume_db = quietDB
	tween.tween_property(current, "volume_db", targetDB, time)
	if not current.playing:
		current.play()

static func fadeOut(time: float) -> void:
	var tween = NodeRelations.createTween()
	tween.tween_property(current, "volume_db", quietDB, time)
	tween.tween_callback(current.stop)
