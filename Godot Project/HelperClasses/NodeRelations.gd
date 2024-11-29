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
	var oldRootNode = rootNode
	oldRootNode.process_mode = Node.PROCESS_MODE_DISABLED
	parent.remove_child(oldRootNode)
	
	# load the new scene
	var newScene = load(path)
	var sceneInstance = newScene.instantiate()
	parent.add_child(sceneInstance)
	
	# free old scene
	oldRootNode.queue_free()

static func setSceneRoot(node: Node) -> void:
	# remove the old scene
	var parent = rootNode.get_parent()
	var oldRootNode = rootNode
	oldRootNode.process_mode = Node.PROCESS_MODE_DISABLED
	parent.remove_child(oldRootNode)
	
	# set it with the node
	parent.add_child(node)

static func createTween() -> Tween:
	return NodeRelations.rootNode.create_tween()
