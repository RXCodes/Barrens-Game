extends Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# make a specific enemy drop lots of cash
	var dummy = $"../../Level/DummyRender12"
	var enemy: EnemyAI = dummy.get_children()[0]
	enemy.cashDrop = 100000
	enemy.cashDropVariance = 0
