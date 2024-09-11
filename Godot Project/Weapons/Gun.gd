class_name Gun extends Sprite2D

# the user-facing display name of this weapon
@export var displayName: String = "Gun"

# the identifier used in source code to identify this weapon
# once set, it is advised NOT to change it to prevent any future mishaps
static var identifier: String = "default_gun"

# the time to wait between shots in seconds before the weapon can be fired again
@export var fireRate: float = 0.2
@export var automatic: bool = true

# how much ammo this weapon can hold per mag
@export var maxMagCapacity: int = 10
@export var currentMagCapacity: int = maxMagCapacity

# how many bullets come from one shot - this can be increased for shotguns
@export var bulletMultiplier: int = 1

# how much time it takes to reload this weapon in seconds
@export var reloadTime: float = 1.5

# the sprite to use for this weapon
@export var sprite: Image = ResourceLoader.load("res://Weapons/Shotgun/Weapon.png")

# override this function and set variables in another script
func _ready() -> void:
	setupWeapon()
	pass

func setupWeapon() -> void:
	pass

func fire() -> void:
	pass

func reload() -> void:
	pass
