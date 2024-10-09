class_name DeathSmokeParticles extends CPUParticles2D

static var particle = preload("res://Particles/SmokeAnimation/SmokeDeath.tscn")
static func spawnParticle(position: Vector2, zIndex: int) -> void:
	var newParticle = particle.instantiate()
	NodeRelations.rootNode.find_child("Level").add_child(newParticle)
	newParticle.global_position = position
	newParticle.z_index = zIndex
	newParticle.set_meta(ZIndexSorter.zScoreKey, position.y + 45)

func _ready() -> void:
	emitting = true
	var decayDelay = lifetime + lifetime_randomness
	await TimeManager.wait(decayDelay)
	queue_free()
