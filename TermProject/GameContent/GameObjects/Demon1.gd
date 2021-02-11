extends KinematicBody2D

signal lootDrop

onready var health = 10
var velocity = Vector2.ZERO

func _process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 200 * delta)
	velocity = move_and_slide(velocity)
	
	if health <= 0:
		queue_free()
	



func _on_Hitbox_area_entered(area):
	print (area.name)
	if area.name == "AttackHitbox":
		getHit()
		velocity = area.velocity_vector * 60
	

func getHit():
	health -= 1
	set_modulate(Color( 0.65, 0.16, 0.16, 1))
	var t = Timer.new()
	t.set_wait_time(0.2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	set_modulate(Color( 1, 1, 1, 1))
	t.queue_free()


func _on_KinematicBody2D_lootDrop():
	pass # Replace with function body.
