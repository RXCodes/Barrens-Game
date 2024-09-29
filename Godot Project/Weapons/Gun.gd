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
var currentMagCapacity: int = maximumMagCapacity

# how much ammo the player starts with when picking up this weapon
@export var startingAmmoCount: int = 50
var leftoverAmmoCount = startingAmmoCount

# how many bullets come from one shot - this can be increased for shotguns
@export var bulletMultiplier: int = 1

# how much time it takes to reload this weapon in seconds
@export var reloadTime: float = 1.5

# the graphic to use for this weapon
@export var texture: Texture2D

# the shell graphic to use for this weapon
@export var shellTexture: Texture2D

# the sound to use when firing the weapon
@export var shootSound: AudioStream

# the sound to use when cocking the weapon
## this requires an animation to trigger this sfx
@export var cockingSound: AudioStream

# the sound to use when reloading the weapon
## this requires an animation to trigger this sfx
@export var reloadSound: AudioStream

var fireDelay = 0.0
var reloadDelay = 0.0
var reloading = false
func process(delta: float) -> void:
	fireDelay -= delta
	if reloadDelay <= 0.0 and reloading:
		if gunInteractor.onFinishReload:
			gunInteractor.onFinishReload.call()
		reloading = false
	reloadDelay -= delta

var shootAudioPlayer: AudioStreamPlayer2D
func fire(holding: bool) -> void:
	if not automatic and holding:
		return
	if fireDelay > 0.0:
		return
	fireDelay = fireRate
	if shootAudioPlayer:
		shootAudioPlayer.play()
	if gunInteractor.onFire:
		gunInteractor.onFire.call()

var reloadAudioPlayer: AudioStreamPlayer2D
func playReloadSound() -> void:
	if reloadAudioPlayer:
		reloadAudioPlayer.play()

func reload() -> void:
	if currentMagCapacity < maximumMagCapacity and leftoverAmmoCount > 0:
		if reloadDelay <= 0.0:
			reloadDelay = reloadTime
			reloading = true
			if gunInteractor.onReload:
				gunInteractor.onReload.call()
				
func cancelReload() -> void:
	if reloadDelay > 0.0:
		reloadDelay = 0.0
		reloading = false
		if gunInteractor.onReloadInterrupted:
			gunInteractor.onReloadInterrupted.call()

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
	rootNode = get_tree().root

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
				weaponData[newWeapon.identifier] = {
					"leftoverAmmo": newWeapon.startingAmmoCount,
					"magCapacity": newWeapon.maximumMagCapacity
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
				newWeapon.leftoverAmmoCount = weaponData["leftoverAmmo"]
				newWeapon.currentMagCapacity = weaponData["magCapacity"]
				if weaponData.has(newWeapon.identifier + ".shoot"):
					newWeapon.shootAudioPlayer = weaponData[newWeapon.identifier + ".shoot"]
				if weaponData.has(newWeapon.identifier + ".cocking"):
					newWeapon.cockingAudioPlayer = weaponData[newWeapon.identifier + ".cocking"]
				if weaponData.has(newWeapon.identifier + ".reload"):
					newWeapon.reloadAudioPlayer = weaponData[newWeapon.identifier + ".reload"]
			newWeapon.gunInteractor = self
			currentWeapon = newWeapon
			gunSprite.texture = currentWeapon.texture
	var gunSprite: Sprite2D
	var onFire: Callable
	var onReload: Callable
	var onFinishReload: Callable
	var onReloadInterrupted: Callable
	var originNode: Node2D
