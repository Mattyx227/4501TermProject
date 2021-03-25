extends Area2D

onready var resource = load("res://GameContent/GameObjects/Enemy/Stats/PlayerStats2.tres")
onready var player = $"../YSort/Player"



func _ready():
	pass


func _on_ToFightArea1_area_entered(area):
	if area.get_parent().name == "Player":
		print(player.health)
		resource.max_health = player.max_health
		resource.max_mana = player.max_mana
		resource.health = player.health
		resource.speed = player.speed
		resource.defense = player.defense
		resource.attack = player.attack
		resource.strength = player.strength
		resource.tenacity = player.tenacity
		resource.magic = player.magic
		resource.swiftness = player.swiftness
		resource.maxEXP = player.maxEXP
		resource.currentEXP = player.currentEXP
		resource.level = player.level
		resource.coin = player.coin
		resource.skillpoint = player.skillpoint
		Tranisiton.change_scene("res://FightArea1.tscn")
		#save("res://GameContent/GameObjects/Enemy/Stats/", resource, 0)
