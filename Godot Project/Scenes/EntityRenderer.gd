extends CanvasGroup
class_name EntityRender

# this is what will be used to render the player, all enemies and npcs
@export var flipHorizontally: bool = false:
	set(flip):
		flipHorizontally = flip
		material.set_shader_parameter("flipX", flip)
var targetNode: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	targetNode = get_children()[0]
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var entityPosition = targetNode.global_position + get_viewport_transform().get_origin()
	var viewportSize = get_viewport_rect().size
	var normalizedXScreenPosition = entityPosition.x / viewportSize.x
	material.set_shader_parameter("currentXPosition", normalizedXScreenPosition)
	pass
