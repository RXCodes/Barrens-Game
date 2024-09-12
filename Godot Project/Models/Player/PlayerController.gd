extends Node2D

var playerSpeed = 3.5

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
		$AnimationTree[key] = animationValues[key]

# Called every physics tick.
var walking = false
var walkingBackwards = false
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
		walkingBackwards = movementVector.x < 0
		currentAnimation = BACKWARDSWALK if walkingBackwards else WALK
		if movementVector.length_squared() == 0:
			currentAnimation = IDLE
			
		# move player
		if walkingBackwards:
			position += movementVector * playerSpeed * 0.6
		else:
			position += movementVector * playerSpeed
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
		var key = event.as_text_key_label()
		if movementKeyBinds.has(key):
			var moveVector = movementKeyBinds[key]
			if event.pressed:
				if not currentMovementKeypresses.has(moveVector):
					currentMovementKeypresses.push_front(moveVector)
			else:
				currentMovementKeypresses.erase(moveVector)
