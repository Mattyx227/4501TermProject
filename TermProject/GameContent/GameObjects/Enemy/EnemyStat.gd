extends Node

var health : int
var mana : int
var max_health : int 
var max_mana : int 
var attack : int
var defense : int
var speed : int

func initialize(starting_stats):
	max_health = starting_stats.max_health
	max_mana = starting_stats.max_mana
	health = starting_stats.max_health
	speed = starting_stats.speed
	defense = starting_stats.defense
	attack = starting_stats.attack
	
