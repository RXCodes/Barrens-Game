extends NinePatchRect

func _ready() -> void:
	var stats = [
		{
			"name": "Total Cash Earned",
			"value": Player.current.totalCashEarned,
			"units": ""
		},
		{
			"name": "Time Survived",
			"value": Player.current.timeSurvived,
			"units": " s"
		},
		{
			"name": "Enemies Defeated",
			"value": Player.current.enemiesDefeated,
			"units": ""
		},
		{
			"name": "Upgrades Received",
			"value": Player.current.upgradesReceived,
			"units": ""
		},
		{
			"name": "Waves Completed",
			"value": Player.current.wavesCompleted,
			"units": ""
		},
		{
			"name": "Damage Dealt",
			"value": Player.current.damageDealt,
			"units": ""
		},
		{
			"name": "Damage Taken",
			"value": Player.current.damageTaken,
			"units": ""
		},
		{
			"name": "Bullets Fired",
			"value": Player.current.bulletsFired,
			"units": ""
		}
	]
	stats.sort_custom(sortStats)
	var statNamesText = ""
	var statValuesText = ""
	for stat: Dictionary in stats:
		statNamesText += stat.get("name") + "\n"
		var value = round(stat.get("value") * 100) / 100
		statValuesText += str(value) + stat.get("units") + "\n"
	$StatisticNames.text = statNamesText
	$StatisticValues.text = statValuesText

func sortStats(stat1: Dictionary, stat2: Dictionary) -> bool:
	return stat1.get("value") > stat2.get("value")
