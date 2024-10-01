class_name ZIndexSorter extends Node
var currentTime: float = 0.0
static var zScoreKey = "zScore"

# this sorts objects so the order that objects are rendered is updating
# objects can be in front of or behind another object depending on y position

# how often to sort objects in seconds
var intervalCheck: float = 0.10

func _process(delta: float) -> void:
	currentTime -= delta
	if currentTime <= 0 or forceSort:
		forceSort = false
		currentTime = intervalCheck
		var children = get_children()
		children.sort_custom(sortFunction)
		var zIndex = 0
		for child in children:
			move_child(child, zIndex)
			zIndex += 1

func sortFunction(a: Node, b: Node):
	var aZScore = a.get_meta(ZIndexSorter.zScoreKey, 0)
	var bZScore = b.get_meta(ZIndexSorter.zScoreKey, 0)
	return aZScore < bZScore

static var forceSort = false
static func sort():
	forceSort = true
