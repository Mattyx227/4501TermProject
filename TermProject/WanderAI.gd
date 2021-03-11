extends Node2D

export(int) var wander_range = 50

onready var timer = $Timer
onready var start_Pos = global_position 
onready var target_Pos = global_position 

func update_tar_Pos():
	var target_vector = Vector2(rand_range(-wander_range, wander_range)
	, rand_range(-wander_range, wander_range))
	target_Pos = start_Pos + target_vector
	
func get_time_left():
	return timer.time_left
	
func start_timer(duration):
	timer.start(duration)
	
func _on_Timer_timeout():
	update_tar_Pos()
	
