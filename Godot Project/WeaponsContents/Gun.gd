class_name Gun extends Node

# DO NOT EDIT THESE PROPERTIES HERE!
# Go into the Inspector on the right to modify properties on a weapon.

@export_group("Gun Info")

## the user-facing display name of this weapon
@export var displayName: String = "Gun"

@export_group("Gun Properties")

## whether or not this gun needs to be cocked before firing again (like a Shotgun)
@export var needsCocking: bool = false
var cockedGun = true:
	set(setBool):
		cockedGun = setBool

## the time to wait between shots in seconds before the weapon can be fired again
@export var fireRate: float = 0.2

## the amount of pushback experienced per shot
@export var recoilAmount: float = 5.0

## if enabled, the gun can fire again while holding the shoot trigger
@export var automatic: bool = true

## how much ammo this weapon can hold per mag
@export var maximumMagCapacity: int = 10
var currentMagCapacity: int:
	set(newAmount):
		currentMagCapacity = newAmount

## how much ammo the player starts with when picking up this weapon
@export var startingAmmoCount: int = 50
var leftoverAmmoCount: int:
	set(newAmount):
		leftoverAmmoCount = newAmount

## how many bullets come from one shot - this can be increased for shotguns
@export var bulletMultiplier: int = 1

## how much time it takes to reload this weapon in seconds
@export var reloadTime: float = 1.5

@export_group("Bullet Properties")

## how much a bullet's trajectory angle deviates in degrees
@export var bulletSpreadDegrees: float = 5

## how far bullets should travel before stopping
@export var targetRange: float = 1000

## how far to deviate from the target range
@export var rangeSpread: float = 50

## how much a single bullet can damage an enemy
@export var targetDamage: float = 10

## how far to deviate from the target damage
@export var damageSpread: float = 3

## the color of the bullet when fired
@export var bulletFireColor: Color = Color.BEIGE

## the color of the trail the bullet leaves behind
@export var bulletTrailColor: Color = Color.DIM_GRAY

## the visual size of the bullet - does not affect collision
@export var bulletSize: float = 0.75

@export_group("Textures")

## this is the graphic used to display this weapon
@export var texture: Texture2D

## the shell graphic to use for this weapon (dropped when cocking a weapon)
## this requires the cocking animation to call an event to trigger at a specific time
@export var shellTexture: Texture2D

## the magazine graphic to use for this weapon (this is dropped when finishing reloading)
## this requires the reloading animation to call an event to trigger at a specific time
@export var magazineTexture: Texture2D

## the drawing offset for the gun texture - this only applies to the player model
@export var drawingOffset: Vector2 = Vector2.ZERO

## how much to offset the right hand to correctly hold the gun - affects the player model only
@export var rightHandOffset: Vector2 = Vector2.ZERO

## drop texture offset
@export var dropTextureOffset: Vector2 = Vector2.ZERO

## drop texture scale
@export var dropTextureScale: float = 1.0

@export_group("Audio")

## the sound to use when firing the weapon
@export var shootSound: AudioStream

## volume offset of the shoot sound in db
@export var shootVolumeOffset: float = -8.0

## pitch variance of the shoot sound
@export var shootPitchVariance: float = 0.15

## the sound to use when cocking the weapon
## -- this requires an animation to trigger this sound effect
@export var cockingSound: AudioStream

## volume offset of the cocking sound
@export var cockingSoundVolumeOffset: float = -3.0

## the sound to use when reloading the weapon
## -- this requires an animation to trigger this sound effect
@export var reloadSound: AudioStream

## volume offset of the reload sound
@export var reloadSoundVolumeOffset: float = -2.0

var canFire = true
var reloading = false

var shootAudioPlayer: AudioStreamPlayer2D
var lastBulletAngleRadians: float
var sourceNode: Node2D
var fileName: String
func fire(holding: bool, angleRadians: float) -> void:
	gunInteractor.gunSprite.texture = gunInteractor.currentWeapon.texture
	if not automatic and holding:
		return
	if not canFire or reloading:
		return
	if currentMagCapacity <= 0:
		return
	if needsCocking:
		if not cockedGun:
			return
		cockedGun = false
	canFire = false
	currentMagCapacity -= 1
	lastBulletAngleRadians = angleRadians
	if shootAudioPlayer:
		shootAudioPlayer.pitch_scale = randfn(1.0, shootPitchVariance)
		shootAudioPlayer.play()
	if gunInteractor.onFire:
		gunInteractor.onFire.call()
	for i in range(bulletMultiplier):
		Bullet.fire(gunInteractor.originNode.global_position + gunInteractor.sourcePositionOffset, angleRadians, self, sourceNode)
	await TimeManager.wait(fireRate / gunInteractor.fireRateDivisor)
	canFire = true

var reloadAudioPlayer: AudioStreamPlayer2D
func playReloadSound() -> void:
	if reloadAudioPlayer:
		reloadAudioPlayer.play()

var reloadTimer: SceneTreeTimer
func reload(forced: bool) -> void:
	if reloading or (not canFire and not forced):
		return
	var modifiedMaximumMagCapacity = round(maximumMagCapacity * gunInteractor.magazineCapacityMultiplier)
	if currentMagCapacity >= modifiedMaximumMagCapacity or leftoverAmmoCount <= 0:
		return
	reloading = true
	if gunInteractor.onReload:
		gunInteractor.onReload.call()
	var newReloadTimer = TimeManager.waitTimer(reloadTime)
	reloadTimer = newReloadTimer
	await reloadTimer.timeout
	if reloadTimer != newReloadTimer:
		return
	var ammoAmountNeeded = modifiedMaximumMagCapacity - currentMagCapacity
	var ammoLeft = max(leftoverAmmoCount - ammoAmountNeeded, 0)
	currentMagCapacity += leftoverAmmoCount - ammoLeft
	leftoverAmmoCount = ammoLeft
	if gunInteractor.onFinishReload:
		gunInteractor.onFinishReload.call()
	reloading = false
	cockedGun = false
	if needsCocking:
		cockWeapon()

func cancelReload() -> void:
	if reloading:
		reloading = false
		reloadTimer = null
		if reloadAudioPlayer:
			reloadAudioPlayer.stop()
		if gunInteractor.onReloadInterrupted:
			gunInteractor.onReloadInterrupted.call()
		gunInteractor.gunSprite.texture = gunInteractor.currentWeapon.texture

func cockWeapon() -> void:
	if cockedGun or not needsCocking:
		return
	if gunInteractor.onCockWeapon:
		gunInteractor.onCockWeapon.call()
		cockedGun = true

func dropShell() -> void:
	if shellTexture:
		var newShell = BulletShell.new()
		newShell.texture = shellTexture
		newShell.global_position = gunInteractor.originNode.global_position + gunInteractor.sourcePositionOffset
		newShell.xVelocity = Vector2.from_angle(lastBulletAngleRadians).x * -35
		NodeRelations.rootNode.find_child("Level").add_child(newShell)

func dropMagazine() -> void:
	if magazineTexture:
		var newMagazine = BulletShell.new()
		newMagazine.texture = magazineTexture
		newMagazine.global_position = gunInteractor.originNode.global_position + gunInteractor.sourcePositionOffset
		NodeRelations.rootNode.find_child("Level").add_child(newMagazine)

var cockingAudioPlayer: AudioStreamPlayer2D
func playCockingSound() -> void:
	if cockingAudioPlayer:
		cockingAudioPlayer.play()

static func gunFromString(string: String) -> Gun:
	var weaponScene = load("res://Weapons/" + string + ".tscn")
	var weapon: Gun = weaponScene.instantiate()
	weapon.fileName = string
	return weapon

# this is what other nodes can use to be able to use guns (see PlayerController.gd)
# yes, this also includes enemies! (or any Node2D)
var gunInteractor: Gun.Interactor
class Interactor:
	var audioStreams = {}
	var weapons = []
	var fireRateDivisor: float = 1.0
	var magazineCapacityMultiplier: float = 1.0
	var damageMultiplier: float = 1.0
	var currentWeapon: Gun:
		set(newWeapon):
			if not weapons.has(newWeapon.displayName):
				# setup audio players for different sounds the gun can play
				if newWeapon.shootSound:
					var newAudioPlayer = AudioStreamPlayer2D.new()
					newAudioPlayer.stream = newWeapon.shootSound
					newAudioPlayer.max_polyphony = 10
					newAudioPlayer.volume_db = newWeapon.shootVolumeOffset 
					originNode.add_child(newAudioPlayer)
					newWeapon.shootAudioPlayer = newAudioPlayer
					audioStreams[newWeapon.displayName + "-shoot"] = newAudioPlayer
				if newWeapon.cockingSound:
					var newAudioPlayer = AudioStreamPlayer2D.new()
					newAudioPlayer.stream = newWeapon.cockingSound
					newAudioPlayer.max_polyphony = 2
					newAudioPlayer.volume_db = newWeapon.cockingSoundVolumeOffset
					originNode.add_child(newAudioPlayer)
					newWeapon.cockingAudioPlayer = newAudioPlayer
					audioStreams[newWeapon.displayName + "-cocking"] = newAudioPlayer
				if newWeapon.reloadSound:
					var newAudioPlayer = AudioStreamPlayer2D.new()
					newAudioPlayer.stream = newWeapon.reloadSound
					newAudioPlayer.max_polyphony = 1
					newAudioPlayer.volume_db = newWeapon.reloadSoundVolumeOffset
					originNode.add_child(newAudioPlayer)
					newWeapon.reloadAudioPlayer = newAudioPlayer
					audioStreams[newWeapon.displayName + "-reload"] = newAudioPlayer
				weapons.append(newWeapon.displayName)
				
				# setup ammo
				newWeapon.currentMagCapacity = newWeapon.maximumMagCapacity
				newWeapon.leftoverAmmoCount = newWeapon.maximumMagCapacity * 3
			else:
				newWeapon.shootAudioPlayer = audioStreams.get(newWeapon.displayName + "-shoot")
				newWeapon.cockingAudioPlayer = audioStreams.get(newWeapon.displayName + "-cocking")
				newWeapon.reloadAudioPlayer = audioStreams.get(newWeapon.displayName + "-reload")
			newWeapon.gunInteractor = self
			currentWeapon = newWeapon
			newWeapon.sourceNode = originNode
			gunSprite.texture = currentWeapon.texture
			if originNode is Player:
				gunSprite.offset = currentWeapon.drawingOffset
			if not newWeapon.cockedGun and newWeapon.leftoverAmmoCount > 0:
				newWeapon.cockWeapon()
	var gunSprite: Sprite2D
	var onFire: Callable
	var onReload: Callable
	var onFinishReload: Callable
	var onReloadInterrupted: Callable
	var onCockWeapon: Callable
	var originNode: Node2D
	var sourcePositionOffset: Vector2
