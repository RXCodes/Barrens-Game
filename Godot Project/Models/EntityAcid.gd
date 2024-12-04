class_name EntityAcid extends CPUParticles2D

static func create() -> EntityAcid:
	return preload("res://Models/EntityAcid.tscn").instantiate()

func _ready() -> void:
	emitting = true

func stopEmitting() -> void:
	emitting = false
	await TimeManager.wait(4.0)
	queue_free()
