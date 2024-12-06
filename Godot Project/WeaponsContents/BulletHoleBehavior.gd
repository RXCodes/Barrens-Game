class_name BulletHole extends Sprite2D

static func create(holePosition: Vector2, grounded: bool) -> void:
	var bulletHole = BulletHole.new()
	bulletHole.texture = preload("res://WeaponsContents/BulletHole.png")
	bulletHole.global_position = holePosition
	var nodeToAddTo = "Under" if grounded else "Level"
	NodeRelations.rootNode.find_child(nodeToAddTo).add_child(bulletHole)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await TimeManager.wait(randf_range(4.5, 8.0))
	var fadeTime = randf_range(4.0, 6.0)
	var tween = NodeRelations.createTween()
	tween.tween_property(self, "self_modulate", Color.TRANSPARENT, fadeTime)
	await TimeManager.wait(fadeTime)
	queue_free()
