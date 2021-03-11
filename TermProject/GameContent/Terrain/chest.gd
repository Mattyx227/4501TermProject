extends StaticBody2D

onready var area = $Area2D

var playerDetect = false

func _process(delta):
	if playerDetect == true && Input.is_action_just_pressed("Interact"):
		$Opened.visible = true
		$Closed.visible = false

#area.getover

func _on_Area2D_area_entered(area):
	if area.name == "PlayerHitBox":
		playerDetect = true

func _on_Area2D_area_exited(area):
		if area.name == "PlayerHitBox":
			playerDetect = false

