extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var node = self
	if node is Sprite2D:
		var zScore = node.global_position.y
		set_meta(ZIndexSorter.zScoreKey, zScore)
	if node is NinePatchRect:
		var zScore = node.global_position.y
		set_meta(ZIndexSorter.zScoreKey, zScore)
