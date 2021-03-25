extends Control


onready var attack = $Attack/Level
onready var coin = $Coin/Level
onready var Defense = $Defense/Level
onready var health = $Health/Level
onready var mana = $Mana/Level
onready var speed = $Speed/Level
onready var strength = $Strength/Level
onready var swiftness = $Swiftness/Level
onready var tenacity = $Tenacity/Level
onready var skillpoint = $Skillpoint/Level
onready var player = get_node("../..")

func updateUI():
	attack.text = str(player.attack)
	coin.text = str(player.coin)
	Defense.text = str(player.defense)
	health.text = str(player.max_health)
	mana.text = str(player.max_mana)
	speed.text = str(player.speed)
	strength.text = str(player.strength)
	swiftness.text = str(player.swiftness)
	tenacity.text = str(player.tenacity)
	skillpoint.text = str(player.skillpoint)

func _on_StrengthButton_pressed():
	print("PRESSED")
	if player.skillpoint > 0:
		player.skillpoint -= 1
		player.strength += 1
