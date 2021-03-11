extends Control

onready var hpBar = $HP
onready var hpEase = $HPease
onready var player = get_parent().get_parent().get_node("YSort/Player")
onready var tween = $Tween

func _ready():
	initHP()
	player.connect("health_changed", self, "health_update")


func initHP():
	hpBar.max_value = player.max_health
	hpBar.value = player.health
	hpEase.max_value = player.max_health

func health_update(health):
	hpBar.value += health
	tween.interpolate_property(hpEase, "value", hpEase.value, hpBar.value, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT, 0.4)
	tween.start()

func max_health_update(max_health):
	hpBar.max_value = max_health
	hpEase.max_value = max_health




