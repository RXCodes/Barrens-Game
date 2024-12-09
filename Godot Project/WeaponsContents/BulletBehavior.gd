class_name Bullet extends NinePatchRect

## this is used for animating the bullet (only visual)
static var targetBulletTravelSpeed = 100
static var bulletTravelSpeedDeviation = 15
static var rotationOffset = -deg_to_rad(90.0)
static var bulletScale = 1.5
static func fire(firePosition: Vector2, angleRadians: float, gun: Gun, sourceNode: Node2D, visualOffset: Vector2) -> void:
	var spreadRadians = deg_to_rad(gun.bulletSpreadDegrees)
	var bulletAngle = randfn(angleRadians, spreadRadians) + rotationOffset
	var maximumDistance = randfn(gun.targetRange, gun.rangeSpread)
	var travelDistance = maximumDistance
	
	# create the trail that's behind the bullet
	var smokeBullet = Bullet.new()
	smokeBullet.global_position = firePosition + visualOffset
	smokeBullet.originPosition = firePosition
	smokeBullet.size = Vector2(gun.bulletSize / bulletScale, 8)
	smokeBullet.pivot_offset = Vector2(4, 8)
	smokeBullet.rotation = bulletAngle
	smokeBullet.fadeTime = randfn(1.0, 0.2)
	smokeBullet.self_modulate = gun.bulletTrailColor
	smokeBullet.smokeBullet = true
	smokeBullet.maximumDistance = (travelDistance / bulletScale) + 10
	NodeRelations.rootNode.find_child("Level").add_child(smokeBullet)
	
	# create the bullet with fire color
	var fireBullet = Bullet.new()
	fireBullet.global_position = firePosition + visualOffset
	fireBullet.originPosition = firePosition
	fireBullet.size = Vector2(gun.bulletSize / bulletScale, 8)
	fireBullet.pivot_offset = Vector2(4, 8)
	fireBullet.rotation = bulletAngle
	fireBullet.self_modulate = gun.bulletFireColor
	fireBullet.maximumDistance = (travelDistance / bulletScale) + 10
	var canvasItemMaterial = CanvasItemMaterial.new()
	canvasItemMaterial.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	fireBullet.material = canvasItemMaterial
	fireBullet.gun = gun
	fireBullet.sourceNode = sourceNode
	fireBullet.z_index = 3
	smokeBullet.add_sibling(fireBullet)

# bullet functionality
var fadeTime: float = 0.3
var normalDirection: Vector2
var sourceNode: Node2D
func _ready() -> void:
	texture = preload("res://WeaponsContents/BulletTrail.png")
	region_rect = Rect2(8, 0, 16, 32)
	patch_margin_left = 4
	patch_margin_top = 0
	patch_margin_right = 4
	patch_margin_bottom = 0
	scale = Vector2(bulletScale, bulletScale)
	normalDirection = Vector2.from_angle(rotation - rotationOffset)
	if normalDirection.y > 0:
		z_index = 1
	if not smokeBullet:
		size.x += 8
		position -= normalDirection * speed * 0.5
	else:
		var tween = NodeRelations.createTween()
		var finalColor = self_modulate
		finalColor.a = 0.0
		tween.tween_property(self, "self_modulate", finalColor, fadeTime)
	await TimeManager.wait(fadeTime)
	queue_free()

var smokeBullet = false
var speed = randfn(targetBulletTravelSpeed, bulletTravelSpeedDeviation)
var maximumDistance = 10000
var distanceTravelled = 0
var frames: int = 0
var gun: Gun
func _process(delta: float) -> void:
	if smokeBullet:
		size.y += speed * 0.5
		distanceTravelled += speed * 0.5
		if distanceTravelled >= maximumDistance:
			size.y = maximumDistance
	else:
		var bulletLength = 75
		size.y += speed
		if size.y >= bulletLength:
			global_position += normalDirection * speed
			size.y = bulletLength
		if distanceTravelled >= maximumDistance:
			size.y -= speed * 2
		distanceTravelled += speed
		if size.y <= 0.05:
			queue_free()

var needsRaycast = true
var originPosition: Vector2
func _physics_process(delta: float) -> void:
	if not needsRaycast:
		return
	needsRaycast = false
	
	# raycasting functionality
	var space_state = get_world_2d().direct_space_state
	var projectoryVector = maximumDistance * normalDirection * bulletScale
	var mask = 2**(3-1) # layer 3
	var enemyQuery = PhysicsRayQueryParameters2D.create(originPosition, global_position + projectoryVector, mask)
	enemyQuery.hit_from_inside = true
	var result = space_state.intersect_ray(enemyQuery)
	if result:
		maximumDistance = global_position.distance_to(result.position) / bulletScale
		if result.collider.has_meta(EnemyAI.enemyAIKey):
			var enemy: EnemyAI = result.collider.get_meta(EnemyAI.enemyAIKey)
			if enemy and gun:
				enemy.call("onHit", result.position)
				enemy.call("damage", randfn(gun.targetDamage * gun.gunInteractor.damageMultiplier, gun.damageSpread), sourceNode)
		return
	
	# create a bullet hole where bullet lands (it didn't hit anything)
	if not smokeBullet:
		BulletHole.create(global_position + projectoryVector, true)
