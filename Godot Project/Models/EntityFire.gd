class_name EntityFire extends CPUParticles2D

static func create() -> EntityFire:
	return preload("res://Models/EntityFire.tscn").instantiate()

func _ready() -> void:
	emitting = true

func stopEmitting() -> void:
	emitting = false
	await TimeManager.wait(4.0)
	queue_free()
