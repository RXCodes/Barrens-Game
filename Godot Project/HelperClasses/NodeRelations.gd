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
