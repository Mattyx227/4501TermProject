extends Area2D


func _process(delta):
	$AnimatedSprite.play()


func _on_Coin_body_entered(body):
	if body.name == "Player":
		body.addCoin()
		queue_free()
