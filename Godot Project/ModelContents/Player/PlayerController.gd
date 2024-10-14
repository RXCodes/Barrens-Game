class_name Player extends CharacterBody2D
static var current: Player
var renderer: EntityRender
var mainAnimationPlayer: AnimationPlayer
var actionAnimationPlayer: AnimationPlayer
var animationTree: AnimationTree
var subviewPort: SubViewport
var textureOutput: Sprite2D
var sprintingSpeedMultiplier = 1.5
var isSprinting = false
var playerSpeed = 3.5
var health = 100.0

var sprintZoomOffset = -0.125
var sprintZoomDampening = 0.075

var gunInteractor: Gun.Interactor
var gunFireShakeDampening = 0.1
var reloadSpeedMultiplier = 0.5
var shooting = false

# setup renderer and gun interactor
func _ready() -> void:
	renderer = get_parent()
	current = self
	mainAnimationPlayer = $Subviewport/Transform/MainAnimationPlayer
	actionAnimationPlayer = $Subviewport/Transform/ActionAnimationPlayer
	animationTree = $Subviewport/Transform/AnimationTree
	subviewPort = $Subviewport
	textureOutput = $TextureDisplay
	await get_tree().process_frame
	gunInteractor = Gun.Interactor.new()
	gunInteractor.originNode = self
	gunInteractor.gunSprite = $Subviewport/Transform/Torso/Coat/LeftElbow/Weapon
	gunInteractor.currentWeapon = Gun.gunFromString("Shotgun")
	gunInteractor.onFire = self.onFire
	gunInteractor.onCockWeapon = self.onCockWeapon
	gunInteractor.onFinishReload = self.onFinishReload
	gunInteractor.onReloadInterrupted = self.onReloadInterrupted
	gunInteractor.onReload = self.onReload
	refreshAmmoDisplay()

# player looping animations
enum {IDLE, WALK, BACKWARDSWALK}
var blendSpeed = 7.5
var currentAnimation = IDLE
var animationValues = {
	"parameters/WalkProgress/blend_amount": 0,
	"parameters/WalkBackwardsProgress/blend_amount": 0
}
func _process(delta: float) -> void:
	# blend animations so we can have smoother transitions between them
	var animSpeed = delta * blendSpeed
	match currentAnimation:
		WALK: animationValues["parameters/WalkProgress/blend_amount"] += animSpeed * 2.0
		BACKWARDSWALK: animationValues["parameters/WalkBackwardsProgress/blend_amount"] += animSpeed * 2.0
	for key in animationValues.keys():
		animationValues[key] -= animSpeed
		animationValues[key] = clampf(animationValues[key], 0.0, 1.0)
		animationTree[key] = animationValues[key]
	
	# calculate normal vector to crosshair and flip player if needed
	var crosshairNormal = Vector2.from_angle(global_position.angle_to_point(Crosshair.current.cursorPosition))
	facingLeft = crosshairNormal.x < 0
	textureOutput.scale.x = -1 if facingLeft else 1
	
	# zoom camera when player is sprinting
	var shouldZoomCamera = Input.is_key_pressed(KEY_SHIFT) and walking and not walkingBackwards
	var targetZoomOffset = sprintZoomOffset if shouldZoomCamera else 0.0
	PlayerCamera.current.sprintingZoomOffset += (targetZoomOffset - PlayerCamera.current.sprintingZoomOffset) * sprintZoomDampening
	
	# weapon functionality
	if shooting:
		var aimAngle = global_position.angle_to_point(Crosshair.current.cursorPosition)
		gunInteractor.currentWeapon.fire(true, aimAngle)
	PlayerCamera.current.gunFireShakeOffset *= 1.0 - gunFireShakeDampening

# Called every physics tick.
var walking = false
var walkingBackwards = false
var facingLeft = false
func _physics_process(delta: float) -> void:
	# player movement
	if currentMovementKeypresses.size() > 0:
		var movementVector = Vector2.ZERO
		walking = true
		
		# calculate the total movement velocity
		for currentMovementVector in  currentMovementKeypresses:
			movementVector += currentMovementVector
		
		# normalize the vector to ensure same speed regardless of direction
		movementVector = movementVector.normalized()
		
		# play a specific animation depending on speed and direction
		walkingBackwards = movementVector.x > 0 if facingLeft else movementVector.x < 0
		currentAnimation = BACKWARDSWALK if walkingBackwards else WALK
		if movementVector.length_squared() == 0:
			currentAnimation = IDLE
		
		# finally move the player
		var speedMultiplier = 1.0
		if isSprinting and not gunInteractor.currentWeapon.reloading and not walkingBackwards:
			speedMultiplier *= sprintingSpeedMultiplier
		elif gunInteractor.currentWeapon.reloading:
			speedMultiplier *= reloadSpeedMultiplier
		animationTree["parameters/Speed/scale"] = speedMultiplier
		movementVector *= playerSpeed * speedMultiplier
		if walkingBackwards:
			movementVector *= 0.6
		move_and_collide(Vector2(movementVector.x, 0))
		move_and_collide(Vector2(0, movementVector.y))
	else:
		currentAnimation = IDLE
		walking = false

# keep track of which movement keys are being pressed
var currentMovementKeypresses: Array = []
var movementKeyBinds = {
	"A": Vector2.LEFT,
	"W": Vector2.UP,
	"S": Vector2.DOWN,
	"D": Vector2.RIGHT
}
func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		var key: String = event.as_text_key_label()
		key = key.trim_prefix("Shift+")
		
		# keep track of WASD movement
		if movementKeyBinds.has(key):
			var moveVector = movementKeyBinds[key]
			if event.pressed:
				if not currentMovementKeypresses.has(moveVector):
					currentMovementKeypresses.push_front(moveVector)
			else:
				currentMovementKeypresses.erase(moveVector)
		
		# just for debugging purposes -- have the player be able to swap weapons
		if not gunInteractor.currentWeapon.reloading and gunInteractor.currentWeapon.canFire:
			if event.pressed:
				if key == "1":
					gunInteractor.currentWeapon = Gun.gunFromString("Shotgun")
					refreshAmmoDisplay()
				elif key == "2":
					gunInteractor.currentWeapon = Gun.gunFromString("AK47")
					refreshAmmoDisplay()
	
	if event is InputEventMouseButton:
		# handle left click
		if event.button_index == 1:
			shooting = event.pressed
			if event.pressed:
				var aimAngle = global_position.angle_to_point(Crosshair.current.cursorPosition)
				gunInteractor.currentWeapon.fire(false, aimAngle)
		# handle right click
		elif event.button_index == 2:
			if event.pressed:
				if gunInteractor.currentWeapon.reloading:
					gunInteractor.currentWeapon.cancelReload()
				else:
					gunInteractor.currentWeapon.reload(false)
	
	# player is sprinting while shift is held
	isSprinting = Input.is_key_pressed(KEY_SHIFT)

func onFire() -> void:
	# briefly shake screen
	var recoilMultiplier = gunInteractor.currentWeapon.recoilAmount
	var random = Vector2(randf_range(-250, 250), randf_range(-250, 250))
	var crosshairNormal = Vector2.from_angle(Crosshair.current.cursorPosition.angle_to_point(global_position + random)).normalized()
	PlayerCamera.current.gunFireShakeOffset += crosshairNormal * recoilMultiplier
	
	# update ammo info and animate it
	AmmoInfoDisplay.gunFired()
	refreshAmmoDisplay()
	
	# play shoot animation
	actionAnimationPlayer.stop()
	actionAnimationPlayer.play("Fire-" + gunInteractor.currentWeapon.displayName)
	gunInteractor.currentWeapon.cockedGun = false
	var shootAnimationTime = actionAnimationPlayer.current_animation_length
	var currentGunIdentifier = gunInteractor.currentWeapon.displayName
	
	# after shoot animation is played, play cocking animation if any
	# this only plays if there's at least one ammo in the magazine to load from
	await TimeManager.wait(shootAnimationTime)
	if currentGunIdentifier == gunInteractor.currentWeapon.displayName:
		if gunInteractor.currentWeapon.currentMagCapacity >= 1:
			gunInteractor.currentWeapon.cockWeapon()
		else:
			# player has no ammo left in magazine - let's reload
			if gunInteractor.currentWeapon.leftoverAmmoCount > 0:
				gunInteractor.currentWeapon.reload(true)
			else:
				# oh, there's no leftover ammo - player can't reload
				print("No ammo left")

func onCockWeapon() -> void:
	actionAnimationPlayer.play("Cock-" + gunInteractor.currentWeapon.displayName)
	refreshAmmoDisplay()

func onReload() -> void:
	actionAnimationPlayer.play("Reload-" + gunInteractor.currentWeapon.displayName)
	Crosshair.reloadWeapon(gunInteractor.currentWeapon.reloadTime)

func onFinishReload() -> void:
	AmmoInfoDisplay.gunReloaded()
	refreshAmmoDisplay()

func refreshAmmoDisplay() -> void:
	AmmoInfoDisplay.setAmmoLeft(gunInteractor.currentWeapon.leftoverAmmoCount)
	AmmoInfoDisplay.setMagCapacity(gunInteractor.currentWeapon.currentMagCapacity)

func onReloadInterrupted() -> void:
	actionAnimationPlayer.stop()
	Crosshair.stopReloadingWeapon()

func callGunMethod(string: String):
	if gunInteractor.currentWeapon.has_method(string):
		gunInteractor.currentWeapon.call(string)
