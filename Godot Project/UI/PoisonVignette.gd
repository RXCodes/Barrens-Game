class_name PoisonVignette extends NinePatchRect

static var current: PoisonVignette

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current = self

var poisonColor = Color("#658942ff")
var poisonColorTransparent = Color("#65894200")
func _process(delta: float) -> void:
	if Player.current:
		show()
		var progress = Player.current.poisonTime / 15.0
		self_modulate = poisonColorTransparent.lerp(poisonColor, progress)
	else:
		hide()
