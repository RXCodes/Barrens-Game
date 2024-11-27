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

func _ready() -> void:
	firstLabel = $"1"
	secondLabel = $"2"
	weaponNameLabel = $WeaponName
	weaponNameInitialPosition = weaponNameLabel.position
	primaryBar = $PrimaryBar
	secondaryBar = $SecondaryBar
	primaryWeaponSprite = $PrimaryWeapon
	secondaryWeaponSprite = $SecondaryWeapon
	secondaryBar.hide()
	secondaryWeaponSprite.hide()
	current = self
	selectPrimary()

static func selectPrimary() -> void:
	firstLabel.self_modulate = Color("97ff94")
	secondLabel.self_modulate = Color.WHITE
	primaryBar.self_modulate = Color("97ff94")
	secondaryBar.self_modulate = Color.WHITE

static func selectSecondary() -> void:
	secondLabel.self_modulate = Color("97ff94")
	firstLabel.self_modulate = Color.WHITE
	secondaryBar.self_modulate = Color("97ff94")
	primaryBar.self_modulate = Color.WHITE

static var weaponTween: Tween
static func setWeaponName(name: String) -> void:
	if not is_instance_valid(weaponNameLabel):
		return
	weaponNameLabel.text = name
	if weaponTween:
		weaponTween.stop()
	weaponNameLabel.position.x = weaponNameInitialPosition.x + 5
	weaponTween = NodeRelations.createTween()
	weaponTween.set_ease(Tween.EASE_OUT)
	weaponTween.set_trans(Tween.TRANS_ELASTIC)
	weaponTween.tween_property(weaponNameLabel, "position", weaponNameInitialPosition, 1.0)

static func secondaryWeaponPickedUp() -> void:
	secondaryWeaponSprite.show()
	secondaryBar.show()
