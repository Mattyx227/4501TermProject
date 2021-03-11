extends Control

onready var hpBar = $HP
onready var hpEase = $HPease
onready var parent = get_parent()
onready var tween = $Tween

func initHP():
	hpBar.max_value = parent.max_health
	hpBar.value = parent.max_health
	hpEase.max_value = parent.max_health

func health_update(health, amount):
	hpBar.value = health - amount
	tween.interpolate_property(hpEase, "value", hpEase.value, hpBar.value, 0.4, Tween.TRANS_SINE, Tween.EASE_OUT, 0.4)
	tween.start()

func max_health_update(max_health):
	hpBar.max_value = max_health
	hpEase.max_value = max_health
