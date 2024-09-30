class_name Bullet extends NinePatchRect

## this is used for animating the bullet (only visual)
static var targetBulletTravelSpeed = 125
static var bulletTravelSpeedDeviation = 15
static var rotationOffset = -deg_to_rad(90.0)
static func fire(position: Vector2, angleRadians: float, gun: Gun) -> void:
	var spreadRadians = deg_to_rad(gun.bulletSpreadDegrees)
	var bulletAngle = randfn(angleRadians, spreadRadians) + rotationOffset
	
	# create the trail that's behind the bullet
	var smokeBullet = Bullet.new()
	smokeBullet.global_position = position
	smokeBullet.size = Vector2(gun.bulletSize / 2.0, 8)
	smokeBullet.pivot_offset = Vector2(4, 8)
	smokeBullet.rotation = bulletAngle
	smokeBullet.fadeTime = randfn(1.0, 0.2)
	smokeBullet.self_modulate = gun.bulletTrailColor
	smokeBullet.smokeBullet = true
	NodeRelations.rootNode.find_child("Level").add_child(smokeBullet)
	
	# create the bullet with fire color
	var fireBullet = Bullet.new()
	fireBullet.global_position = position
	fireBullet.size = Vector2(gun.bulletSize / 2.0, 8)
	fireBullet.pivot_offset = Vector2(4, 8)
	fireBullet.rotation = bulletAngle
	fireBullet.self_modulate = gun.bulletFireColor
	fireBullet.fadeTime = randfn(0.3, 0.1)
	var canvasItemMaterial = CanvasItemMaterial.new()
	canvasItemMaterial.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
	fireBullet.material = canvasItemMaterial
	NodeRelations.rootNode.find_child("Level").add_child(fireBullet)
	
	# forcefully order the bullets for this frame
	ZIndexSorter.sort()

var fadeTime: float = 0.3
var normalDirection: Vector2
func _ready() -> void:
	texture = load("res://Weapons/BulletTrail.png")
	region_rect = Rect2(8, 0, 16, 32)
	patch_margin_left = 4
	patch_margin_top = 4
	patch_margin_right = 4
	patch_margin_bottom = 4
	scale = Vector2(1.5, 1.5)
	set_meta(ZIndexSorter.zScoreKey, global_position.y)
	normalDirection = Vector2.from_angle(rotation - rotationOffset)
	if normalDirection.y < 0:
		set_meta(ZIndexSorter.zScoreKey, global_position.y - 50)
	var tween = get_tree().create_tween()
	var finalColor = self_modulate
	finalColor.a = 0.0
	tween.tween_property(self, "self_modulate", finalColor, fadeTime)
	tween.tween_callback(free)

var smokeBullet = false
var speed = randfn(targetBulletTravelSpeed, bulletTravelSpeedDeviation)
var maximumDistance = 100
func _process(delta: float) -> void:
	if smokeBullet:
		size.y += speed
	else:
		size.y += speed * 0.8
		size.x *= 0.9
		global_position += normalDirection * speed * 0.4
