extends Area2D


func _ready():
	pass


func _on_ToFightArea1_area_entered(area):
	if area.get_parent().name == "Player":
		Tranisiton.change_scene("res://FightArea1.tscn")
