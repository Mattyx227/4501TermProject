extends Node	

class_name EnemyStats

onready var stats = get_node("Stats")

export var starting_stats : Resource

func _ready():
	stats.initialize(starting_stats)
	print(stats.max_health)

