tool
extends Node	

class_name EnemyStats

onready var stats = $Stats

export var starting_stats : Resource

func _ready():
	stats.initialize(starting_stats)


func initialize(starting_stats):
	max_health = starting_stats.max_health
	max_mana = starting_stats.max_mana
	health = starting_stats.max_health
	speed = starting_stats.speed
	defense = starting_stats.defense
	attack = starting_stats.attck
