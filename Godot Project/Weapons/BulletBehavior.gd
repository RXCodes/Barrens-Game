class_name Bullet extends NinePatchRect

## this is used for animating the bullet (only visual)
static var targetBulletTravelSpeed = 200
static var bulletTravelSpeedDeviation = 15
static var rotationOffset = -deg_to_rad(90.0)
static var bulletScale = 1.5
static func fire(position: Vector2, angleRadians: float, gun: Gun) -> void:
	var spreadRadians = deg_to_rad(gun.bulletSpreadDegrees)
	var bulletAngle = randfn(angleRadians, spreadRadians) + rotationOffset
	var maximumDistance = randfn(gun.targetRange, gun.rangeSpread)
	var travelDistance = maximumDistance
	
	# create the trail that's behind the bullet
	var smokeBullet = Bullet.new()
	smokeBullet.global_position = position
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
	fireBullet.global_position = position
	fireBullet.size = Vector2(gun.bulletSize / bulletScale, 8)
	fireBullet.pivot_offset = Vector2(4, 8)
	fireBullet.rotation = bulletAngle
	fireBullet.self_modulate = gun.bulletFireColor
	fireBullet.fadeTime = randfn(0.3, 0.1)
	fireBullet.maximumDistance = (travelDistance / bulletScale) + 10
	var canvasItemMaterial = CanvasItemMaterial.new()
	canvasItemMaterial.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	fireBullet.material = canvasItemMaterial
	fireBullet.gun = gun
	NodeRelations.rootNode.find_child("Level").add_child(fireBullet)
	
	# forcefully order the bullets for this frame
	ZIndexSorter.sort()

# bullet functionality
var fadeTime: float = 0.3
var normalDirection: Vector2
func _ready() -> void:
	texture = load("res://Weapons/BulletTrail.png")
	region_rect = Rect2(8, 0, 16, 32)
	patch_margin_left = 4
	patch_margin_top = 4
	patch_margin_right = 4
	patch_margin_bottom = 4
	scale = Vector2(bulletScale, bulletScale)
	var zScore = global_position.y
	normalDirection = Vector2.from_angle(rotation - rotationOffset)
	if normalDirection.y < 0:
		zScore -= 50
	else:
		zScore += 50
	if smokeBullet:
		zScore -= 1
	else:
		size.x += 5
	set_meta(ZIndexSorter.zScoreKey, zScore)
	var tween = get_tree().create_tween()
	var finalColor = self_modulate
	finalColor.a = 0.0
	tween.tween_property(self, "self_modulate", finalColor, fadeTime)
	tween.tween_callback(free)

var smokeBullet = false
var speed = randfn(targetBulletTravelSpeed, bulletTravelSpeedDeviation)
var maximumDistance = 10000
var distanceTravelled = 0
var frames = 0
var gun: Gun
func _process(delta: float) -> void:
	if smokeBullet:
		size.y += speed * 0.7
		distanceTravelled += speed * 0.7
		if distanceTravelled >= maximumDistance:
			size.y = maximumDistance
	else:
		if frames == 0:
			global_position -= normalDirection * speed * 0.5
		size.y += speed * 0.8
		scale.x *= 0.95
		global_position += normalDirection * speed * 0.4
		distanceTravelled += speed * 1.2
		if distanceTravelled >= maximumDistance:
			size.y -= speed * 0.95
			if size.y <= 10 and frames >= 3:
				free()
			elif size.y <= 10:
				size.y = maximumDistance * 0.5
	frames += 1

var needsRaycast = true
func _physics_process(delta: float) -> void:
	if not needsRaycast:
		return
	needsRaycast = false
	
	# raycasting functionality
	var space_state = get_world_2d().direct_space_state
	var projectoryVector = maximumDistance * normalDirection * bulletScale
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + projectoryVector)
	var result = space_state.intersect_ray(query)
	if result:
		maximumDistance = global_position.distance_to(result.position) / bulletScale
		var enemy = result.collider.get_meta(EnemyAI.enemyAIKey)
		if enemy and gun:
			enemy.call("onHit", result.position)
			enemy.call("damage", randfn(gun.targetDamage, gun.damageSpread))
		return
	
	# create a bullet hole where bullet lands (it didn't hit anything)
	BulletHole.create(global_position + projectoryVector, true)
