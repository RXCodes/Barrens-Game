class_name EntityLightning extends CPUParticles2D

static func create() -> EntityLightning:
	return preload("res://Models/EntityLightning.tscn").instantiate()

func _ready() -> void:
	emitting = true

func stopEmitting() -> void:
	emitting = false
	await TimeManager.wait(4.0)
	queue_free()
