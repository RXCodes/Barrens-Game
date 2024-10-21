class_name NodeRelations extends Node

## gets all children (recursively) of a node
static func getChildrenRecursive(node: Node, array:=[]) -> Array:
	array.push_back(node)
	for child in node.get_children():
		array = getChildrenRecursive(child, array)
	return array

## gets the root node
static var rootNode: Node
func _ready() -> void:
	rootNode = get_tree().root.get_children()[0]

static func loadScene(path: String) -> void:
	# remove the old scene
	var parent = rootNode.get_parent()
	parent.remove_child(rootNode)
	
	# load the new scene
	var newScene = load(path)
	var sceneInstance = newScene.instantiate()
	parent.add_child(sceneInstance)

static func createTween() -> Tween:
	return NodeRelations.rootNode.create_tween()
