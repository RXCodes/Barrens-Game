class_name Save

# deals with persisting pieces of information to be retrieved later
const savePath = "user://save.dat"
static var saveData = {}
static var temporary = {}

static func _static_init() -> void:
	# load contents from save file if it exists
	if FileAccess.file_exists(savePath):
		var saveFile = FileAccess.open(savePath, FileAccess.READ)
		saveData = saveFile.get_var()
		saveFile.close()
		print("--- Loaded Save File ---")
		print(saveData)
		print("--- End Save File ---")
	else:
		print("No save file found")

## retrieve a specific value from the save file
static func loadValue(key: String, defaultValue: Variant) -> Variant:
	return saveData.get(key, defaultValue)

## store a specific value to the save file
static func saveValue(key: String, value: Variant) -> void:
	if value == null:
		# when null is provided, we assume the value should be delated
		saveData.erase(key)
	else:
		saveData[key] = value
	var saveFile = FileAccess.open(savePath, FileAccess.WRITE)
	saveFile.store_var(saveData)
	saveFile.close()

## reset the save file
static func resetSave() -> void:
	saveData.clear()
	var saveFile = FileAccess.open(savePath, FileAccess.WRITE)
	saveFile.store_var(saveData)
	saveFile.close()

# temporary save data does not persist between sessions - this is used to share information between scenes
## retrieve a specific temporary value
static func getTemporaryValue(key: String, defaultValue: Variant) -> Variant:
	return temporary.get(key, defaultValue)

## store a temporary value
static func setTemporaryValue(key: String, value: Variant) -> void:
	if value == null:
		# when null is provided, we assume the value should be delated
		temporary.erase(key)
	else:
		temporary[key] = value
