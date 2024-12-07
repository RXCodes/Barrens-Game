class_name BluePortal extends Node2D

static func create(position: Vector2) -> BluePortal:
	var portal = preload("res://ModelContents/BluePortal/BluePortal.tscn").instantiate()
	NodeRelations.rootNode.find_child("Level").add_child(portal)
	portal.global_position = position
	return portal

# Called when the node enters the scene tree for the first time.
var shouldTeleportEnemies = false
var beingCreated = true
func _ready() -> void:
	hide()
	$AnimationPlayer.play("Summon")
	await get_tree().physics_frame
	show()
	await TimeManager.wait(1.2)
	beingCreated = false
	shouldTeleportEnemies = true
	for i in range(4):
		ExplosionFragment.create(global_position, Color("#4f81fe"))
	if Player.current:
		var distanceToPlayer = Player.current.global_position.distance_to(global_position)
		var shakeIntensity = 120 - (distanceToPlayer * 0.02)
		if shakeIntensity > 0:
			PlayerCamera.current.shakeScreen(shakeIntensity, 3.5)
	await TimeManager.wait(10.0)
	shouldTeleportEnemies = false
	await TimeManager.wait(6.5)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$SubViewport/Portal.rotation_degrees += delta * 360
