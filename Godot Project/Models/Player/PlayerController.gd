extends Node2D

var playerSpeed = 3.5

# Called when the player enters the scene tree for the first time.
func _ready() -> void:
	$MainAnimationPlayer.play("Idle")

# Called every physics tick.
var walking = false
var walkingBackwards = false
func _physics_process(delta: float) -> void:
	# player movement
	if currentMovementKeypresses.size() > 0:
		var movementVector = currentMovementKeypresses[0]
		
		# walking animations
		var currentlyWalkingBackwards = movementVector.x < 0
		var shouldChangeAnimation = false
		if not walking:
			shouldChangeAnimation = true
			walking = true
		if not shouldChangeAnimation:
			shouldChangeAnimation = currentlyWalkingBackwards != walkingBackwards
		walkingBackwards = currentlyWalkingBackwards
		if shouldChangeAnimation: 
			if walkingBackwards:
				$MainAnimationPlayer.play("Walk Backwards")
			else:
				$MainAnimationPlayer.play("Walk")
			
		# move player
		if walkingBackwards:
			position += movementVector * playerSpeed * 0.6
		else:
			position += movementVector * playerSpeed
	else:
		if walking:
			$MainAnimationPlayer.play("Idle")
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
