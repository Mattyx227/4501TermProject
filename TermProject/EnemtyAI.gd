extends Area2D

var player = null

func see_player():
	return player != null

func _on_Detection_body_entered(body):
	if body.is_in_group("Player"):
		if body.alive == true:
			player = body
		else:
			player = null
	


func _on_Detection_body_exited(body):
	if body.is_in_group("Player"):
		player = null
