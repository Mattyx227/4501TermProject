extends Control

onready var hpBar = $HP
onready var hpEase = $HPease
onready var level = $Level
onready var player = get_parent().get_parent().get_node("YSort/Player")
onready var tween = $Tween
onready var HPtext = $HP/HPtext
onready var EXPbar = $ExpBar/Bar
onready var EXPtext = $ExpBar/EXPtext
onready var deadScreen = $DeadScreen

func _ready():
	initHP()
	player.connect("health_changed", self, "health_update")
	player.connect("maxhealth_changed", self, "max_health_update")
	player.connect("level_changed", self, "level_update")

func _process(delta):
	level.text = "Lvl " + str(player.level)
	EXPbar.max_value = player.maxEXP
	EXPtext.text = str(player.currentEXP) + "/" + str(player.maxEXP)
	EXPbar.value = player.currentEXP
	if player.alive == false:
		deadScreen.visible = true
		
	

func initHP():
	hpBar.max_value = player.max_health
	hpBar.value = player.health
	hpEase.value = player.health
	hpEase.max_value = player.max_health
	HPtext.text = str(hpBar.value) + "/" + str(hpBar.max_value)

func health_update(health):
	hpBar.value += health
	HPtext.text = str(hpBar.value) + "/" + str(hpBar.max_value)
	tween.interpolate_property(hpEase, "value", hpEase.value, hpBar.value, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT, 0.4)
	tween.start()

func max_health_update(max_health):
	print("UPDATING HEALTH")
	hpBar.max_value = max_health
	print(hpBar.max_value)
	hpEase.max_value = max_health
	HPtext.text = str(hpBar.value) + "/" + str(hpBar.max_value)

func _on_RespawnButton_button_up():
	player.respawn()
	deadScreen.visible = false
	hpBar.value = player.max_health
	hpBar.max_value = player.max_health
	HPtext.text = str(hpBar.value) + "/" + str(hpBar.max_value)
	

