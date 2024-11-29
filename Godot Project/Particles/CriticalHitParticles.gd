class_name CriticalHitParticles extends CPUParticles2D

static var particles = preload("res://Particles/CriticalHitParticles.tscn")
static func createParticles(position: Vector2) -> void:
	var newParticles = particles.instantiate()
	NodeRelations.rootNode.find_child("Level").add_child(newParticles)
	newParticles.global_position = position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AudioStreamPlayer2D.pitch_scale = randfn(1.0, 0.075)
	emitting = true
	await TimeManager.wait(3.0)
	queue_free()
