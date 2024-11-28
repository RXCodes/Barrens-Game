class_name WeaponSlots extends TextureRect

static var current: WeaponSlots
static var firstLabel: Label
static var secondLabel: Label
static var weaponNameLabel: Label
static var weaponNameInitialPosition: Vector2
static var primaryBar: TextureProgressBar
static var secondaryBar: TextureProgressBar
static var primaryWeaponSprite: Sprite2D
static var secondaryWeaponSprite: Sprite2D
static var currentSlot = 1
static var weaponChangedSound: AudioStreamPlayer

func _ready() -> void:
	firstLabel = $"1"
	secondLabel = $"2"
	weaponNameLabel = $WeaponName
	weaponNameInitialPosition = weaponNameLabel.position
	primaryBar = $PrimaryBar
	secondaryBar = $SecondaryBar
	primaryWeaponSprite = $PrimaryWeapon
	secondaryWeaponSprite = $SecondaryWeapon
	weaponChangedSound = $WeaponChanged
	secondaryBar.hide()
	secondaryWeaponSprite.hide()
	current = self
	selectPrimary()

static func selectPrimary() -> void:
	firstLabel.self_modulate = Color("97ff94")
	secondLabel.self_modulate = Color.WHITE
	primaryBar.self_modulate = Color("97ff94")
	secondaryBar.self_modulate = Color.WHITE
	if currentSlot != 1:
		weaponChanged()
	currentSlot = 1

static func selectSecondary() -> void:
	secondLabel.self_modulate = Color("97ff94")
	firstLabel.self_modulate = Color.WHITE
	secondaryBar.self_modulate = Color("97ff94")
	primaryBar.self_modulate = Color.WHITE
	if currentSlot != 2:
		weaponChanged()
	currentSlot = 2

static var weaponTween: Tween
static func setWeaponName(name: String) -> void:
	if not is_instance_valid(weaponNameLabel):
		return
	weaponNameLabel.text = name

static func weaponChanged() -> void:
	# animate the weapon name
	if weaponTween:
		weaponTween.stop()
	weaponNameLabel.position.x = weaponNameInitialPosition.x + 5
	weaponTween = NodeRelations.createTween()
	weaponTween.set_ease(Tween.EASE_OUT)
	weaponTween.set_trans(Tween.TRANS_ELASTIC)
	weaponTween.tween_property(weaponNameLabel, "position", weaponNameInitialPosition, 1.0)
	
	# play a sound effect
	weaponChangedSound.pitch_scale = randfn(1.0, 0.08)
	weaponChangedSound.play()

static func secondaryWeaponPickedUp() -> void:
	secondaryWeaponSprite.show()
	secondaryBar.show()

static func setPrimaryWeapon(gun: Gun) -> void:
	primaryWeaponSprite.texture = gun.texture
	primaryWeaponSprite.offset = gun.drawingOffset
	
static func setSecondaryWeapon(gun: Gun) -> void:
	secondaryWeaponSprite.texture = gun.texture
	secondaryWeaponSprite.offset = gun.drawingOffset
