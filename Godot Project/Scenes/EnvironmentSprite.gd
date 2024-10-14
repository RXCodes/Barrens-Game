extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var zScore = global_position.y
	set_meta(ZIndexSorter.zScoreKey, zScore)
