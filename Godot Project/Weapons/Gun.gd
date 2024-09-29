class_name Gun extends Node2D

## DO NOT EDIT THESE PROPERTIES HERE!
## Go into the Inspector on the right to modify properties on a weapon.

# how this gun is identified in source code
@export var identifier: String = "default_gun"

# the user-facing display name of this weapon
@export var displayName: String = "Gun"

# the time to wait between shots in seconds before the weapon can be fired again
@export var fireRate: float = 0.2
@export var automatic: bool = true

# how much ammo this weapon can hold per mag
@export var maximumMagCapacity: int = 10
var currentMagCapacity: int:
	set(newAmount):
		gunInteractor.weaponData[identifier]["magCapacity"] = newAmount
		currentMagCapacity = newAmount

# how much ammo the player starts with when picking up this weapon
@export var startingAmmoCount: int = 50
var leftoverAmmoCount: int:
	set(newAmount):
		gunInteractor.weaponData[identifier]["leftoverAmmo"] = newAmount
		leftoverAmmoCount = newAmount

# how many bullets come from one shot - this can be increased for shotguns
@export var bulletMultiplier: int = 1

# how much time it takes to reload this weapon in seconds
@export var reloadTime: float = 1.5

# the graphic to use for this weapon
@export var texture: Texture2D

# the shell graphic to use for this weapon
@export var shellTexture: Texture2D

# the magazine graphic to use for this weapon
@export var magazineTexture: Texture2D

# the sound to use when firing the weapon
@export var shootSound: AudioStream

# the sound to use when cocking the weapon
## this requires an animation to trigger this sfx
@export var cockingSound: AudioStream

# whether or not this gun needs to be cocked before firing again (Shotgun)
@export var needsCocking: bool = false
var cockedGun = true:
	set(setBool):
		gunInteractor.weaponData[identifier]["cocked"] = setBool
		cockedGun = setBool

# the sound to use when reloading the weapon
## this requires an animation to trigger this sfx
@export var reloadSound: AudioStream

var canFire = true
var reloading = false

var shootAudioPlayer: AudioStreamPlayer2D
func fire(holding: bool) -> void:
	if not automatic and holding:
		return
	if not canFire:
		return
	if needsCocking:
		if not cockedGun:
			return
		cockedGun = false
	canFire = false
	currentMagCapacity -= 1
	if shootAudioPlayer:
		shootAudioPlayer.play()
	if gunInteractor.onFire:
		gunInteractor.onFire.call()
	await TimeManager.wait(fireRate)
	canFire = true

var reloadAudioPlayer: AudioStreamPlayer2D
func playReloadSound() -> void:
	if reloadAudioPlayer:
		reloadAudioPlayer.play()

var reloadTimer: SceneTreeTimer
func reload() -> void:
	if currentMagCapacity < maximumMagCapacity and leftoverAmmoCount > 0:
		if not reloading:
			if leftoverAmmoCount == 0 and currentMagCapacity < maximumMagCapacity:
				return
			reloading = true
			if gunInteractor.onReload:
				gunInteractor.onReload.call()
			reloadTimer = TimeManager.waitTimer(reloadTime)
			await reloadTimer.timeout
			if gunInteractor.onFinishReload:
				gunInteractor.onFinishReload.call()
			reloading = false
			var ammoAmountNeeded = maximumMagCapacity - currentMagCapacity
			var ammoLeft = max(leftoverAmmoCount - ammoAmountNeeded, 0)
			currentMagCapacity = leftoverAmmoCount - ammoLeft
			leftoverAmmoCount = ammoLeft
			if needsCocking:
				cockWeapon()

func cancelReload() -> void:
	if reloading:
		reloading = false
		reloadTimer.free()
		if gunInteractor.onReloadInterrupted:
			gunInteractor.onReloadInterrupted.call()

func cockWeapon() -> void:
	if cockedGun:
		return
	if not needsCocking:
		return
	if gunInteractor.onCockWeapon:
		gunInteractor.onCockWeapon.call()
		cockedGun = true

static var shellBehaviorScript: Script = preload("res://Weapons/ShellBehavior.gd")
func dropShell() -> void:
	if shellTexture:
		var newShell = Sprite2D.new()
		newShell.set_script(shellBehaviorScript)
		newShell.texture = shellTexture
		newShell.global_position = gunInteractor.gunSprite.global_position
		newShell.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		rootNode.add_child(newShell)

var cockingAudioPlayer: AudioStreamPlayer2D
func playCockingSound() -> void:
	if cockingAudioPlayer:
		cockingAudioPlayer.play()

static var rootNode: Node
func _ready() -> void:
	weaponsNode = get_parent()
	rootNode = get_tree().root.get_children()[0]

static var weaponsNode: Node
static func gunFromString(string: String) -> Gun:
	return weaponsNode.find_child(string).duplicate()

# this is what other nodes can use to be able to use guns (see PlayerController.gd)
# yes, this also includes enemies! (or any Node2D)
var gunInteractor: Gun.Interactor
class Interactor:
	var weaponData = {}
	var currentWeapon: Gun:
		set(newWeapon):
			if not weaponData.has(newWeapon.identifier):
				# we're going to keep track of specific properties so we can access them
				# again when switching between weapons
				weaponData[newWeapon.identifier] = {
					"leftoverAmmo": newWeapon.startingAmmoCount,
					"magCapacity": newWeapon.maximumMagCapacity,
					"cocked": true
				}
				
				# setup audio players for different sounds the gun can play
				if newWeapon.shootSound:
					var newAudioPlayer = AudioStreamPlayer2D.new()
					newAudioPlayer.stream = newWeapon.shootSound
					newAudioPlayer.max_polyphony = 10
					originNode.add_child(newAudioPlayer)
					newWeapon.shootAudioPlayer = newAudioPlayer
					newAudioPlayer.name = newWeapon.identifier + ".shoot"
				if newWeapon.cockingSound:
					var newAudioPlayer = AudioStreamPlayer2D.new()
					newAudioPlayer.stream = newWeapon.cockingSound
					newAudioPlayer.max_polyphony = 2
					originNode.add_child(newAudioPlayer)
					newWeapon.cockingAudioPlayer = newAudioPlayer
					newAudioPlayer.name = newWeapon.identifier + ".cocking"
				if newWeapon.reloadSound:
					var newAudioPlayer = AudioStreamPlayer2D.new()
					newAudioPlayer.stream = newWeapon.reloadSound
					newAudioPlayer.max_polyphony = 1
					originNode.add_child(newAudioPlayer)
					newWeapon.reloadAudioPlayer = newAudioPlayer
					newAudioPlayer.name = newWeapon.identifier + ".reload"
			else:
				if weaponData.has(newWeapon.identifier + ".shoot"):
					newWeapon.shootAudioPlayer = weaponData[newWeapon.identifier + ".shoot"]
				if weaponData.has(newWeapon.identifier + ".cocking"):
					newWeapon.cockingAudioPlayer = weaponData[newWeapon.identifier + ".cocking"]
				if weaponData.has(newWeapon.identifier + ".reload"):
					newWeapon.reloadAudioPlayer = weaponData[newWeapon.identifier + ".reload"]
			newWeapon.gunInteractor = self
			currentWeapon = newWeapon
			newWeapon.leftoverAmmoCount = weaponData[newWeapon.identifier]["leftoverAmmo"]
			newWeapon.currentMagCapacity = weaponData[newWeapon.identifier]["magCapacity"]
			newWeapon.cockedGun = weaponData[newWeapon.identifier]["cocked"]
			gunSprite.texture = currentWeapon.texture
	var gunSprite: Sprite2D
	var onFire: Callable
	var onReload: Callable
	var onFinishReload: Callable
	var onReloadInterrupted: Callable
	var onCockWeapon: Callable
	var originNode: Node2D
