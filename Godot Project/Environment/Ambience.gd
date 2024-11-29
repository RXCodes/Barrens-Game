class_name InGameAmbience extends AudioStreamPlayer

static var current: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self
