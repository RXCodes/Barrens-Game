class_name HitParticle extends AnimatedSprite2D

static var particle = preload("res://Particles/HitAnimation/HitParticle.tscn")
static func spawnParticle(position: Vector2, zIndex: int) -> void:
	var newParticle = particle.instantiate()
	NodeRelations.rootNode.find_child("Level").add_child(newParticle)
	newParticle.global_position = position
	newParticle.z_index = zIndex

func _ready() -> void:
	rotation_degrees = randfn(0, 60)
	speed_scale = randf_range(3.5, 9.5)
	scale.x = randf_range(1.75, 3.5)
	scale.y = scale.x
	animation_looped.connect(animationFinished)
	play()

func animationFinished() -> void:
	queue_free()
