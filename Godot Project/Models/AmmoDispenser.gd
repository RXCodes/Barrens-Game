extends Sprite2D

## cooldown in seconds
@export var respawnCooldown = 80.0

var lastSpawnedAmmo
var currentCooldown = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	currentCooldown = randf_range(1.0, 5.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not lastSpawnedAmmo:
		$Countdown.show()
		$Countdown.text = str(ceil(currentCooldown))
		currentCooldown -= delta
		if currentCooldown <= 0:
			$Countdown.hide()
			spawnAmmo()

func spawnAmmo() -> void:
	lastSpawnedAmmo = EnemySpawner.spawnEnemy("AmmoPickup", global_position)
	currentCooldown = respawnCooldown
	$Spawn.pitch_scale = randfn(1.0, 0.05)
	$Spawn.play()
