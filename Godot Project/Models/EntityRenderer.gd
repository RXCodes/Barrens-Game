extends CanvasGroup
class_name EntityRender
var targetNode: Node2D

# this is what will be used to render the player, all enemies and npcs
var flipHorizontally: bool = false:
	set(flip):
		flipHorizontally = flip
		material.set_shader_parameter("flipX", flip)
		
## how much to offset the z index
@export var entityZIndexOffset = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targetNode = get_children()[0]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var entityPosition = targetNode.get_global_transform_with_canvas().origin
	var viewportSize = get_viewport_rect().size
	var normalizedXScreenPosition = entityPosition.x / viewportSize.x
	material.set_shader_parameter("currentXPosition", normalizedXScreenPosition)
	var zScore = targetNode.global_position.y + entityZIndexOffset
	set_meta(ZIndexSorter.zScoreKey, zScore)
