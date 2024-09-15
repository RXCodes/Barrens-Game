extends Sprite2D

# responsible for creating the ground in the scene

func _ready() -> void:
	self.region_rect = Rect2(0, 0, 100000, 100000)
