extends CanvasGroup
class_name EntityRender
var targetNode: Node2D
var canvasLayer: CanvasLayer

# this is what will be used to render the player, all enemies and npcs
## how much to offset the z index
@export var entityZIndexOffset = 0

var layerIndex

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targetNode = get_children()[0]
	canvasLayer = find_child("CanvasLayer")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var zScore = targetNode.global_position.y + entityZIndexOffset
	set_meta(ZIndexSorter.zScoreKey, zScore)
