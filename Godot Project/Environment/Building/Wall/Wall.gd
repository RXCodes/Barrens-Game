@tool
extends ReferenceRect

@export var primaryColor: Color
@export var secondaryColor: Color
@export var floorColor: Color
@export var separatorColor: Color
@export var depth: float = 60

# Called when the node enters the scene tree for the first time.
var wall: NinePatchRect
var floor: NinePatchRect
var vignette: NinePatchRect
var floorVignette: NinePatchRect
var supports: NinePatchRect
var topSeparator: NinePatchRect
func _ready() -> void:
	wall = $Wall
	supports = $Supports
	floor = $Floor
	vignette = $Vignette
	floorVignette = $FloorVignette
	topSeparator = $TopSeparator
	updateStructure()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		updateStructure()

func updateStructure() -> void:
	wall.size = scale * Vector2(37, 31)
	wall.scale = Vector2.ONE / scale
	wall.self_modulate = primaryColor
	supports.size = scale * Vector2(37, 31)
	supports.scale = Vector2.ONE / scale
	supports.self_modulate = secondaryColor
	vignette.size = scale * Vector2(37, 31)
	vignette.scale = Vector2.ONE / scale
	floor.scale = Vector2.ONE / scale
	floorVignette.scale = Vector2.ONE / scale
	floor.size.x = wall.size.x
	floor.size.y = depth
	floor.position.x = 0
	floor.position.y = wall.size.y * wall.scale.y
	floor.position.y -= floor.size.y / scale.y
	floor.self_modulate = floorColor
	floorVignette.scale = floor.scale
	floorVignette.size = floor.size
	floorVignette.position = floor.position
	vignette.size.y -= floor.size.y
	topSeparator.size.x = wall.size.x
	topSeparator.size.y = 8
	topSeparator.self_modulate = separatorColor
	topSeparator.scale = wall.scale
	topSeparator.position.y = -4 / scale.y
