extends KinematicBody2D

signal lootDrop

const MAX_SPEED = 50
const ACCELERATION = 200
const FRICTION = 5000

enum State{
	IDLE,
	WANDER,
	CHASE,
	HIT,
}

onready var health = 100
onready var playerdetection = $Detection
onready var sprite = $AnimatedSprite
onready var wanderAI = $WanderAI
var current_state = State.IDLE
var coin = preload("res://GameContent/GameObjects/Coin.tscn")
var coin_instance = coin.instance()



var knockBack = Vector2.ZERO
var velocity = Vector2.ZERO


func _process(delta):

	
	
	
	if health <= 0:
		death()
		
	match current_state:
		State.IDLE:
			seek_player()
			sprite.play("Idle")
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			if wanderAI.get_time_left() == 0:
				current_state = pick_state([State.IDLE, State.WANDER])
				wanderAI.start_timer(rand_range(1, 2))
		State.WANDER:
			seek_player()
			sprite.play("Attack")
			
			if wanderAI.get_time_left() == 0:
				current_state = pick_state([State.IDLE, State.WANDER])
				wanderAI.start_timer(rand_range(1, 2))
			var direction = global_position.direction_to(wanderAI.target_Pos).normalized()
			velocity = velocity.move_toward(direction * MAX_SPEED, FRICTION * delta)
			sprite.flip_h = velocity.x <= 0
			
		State.CHASE:
			seek_player()
			sprite.flip_h = velocity.x < 0
			var player = playerdetection.player
			if player != null:
				var direction = global_position.direction_to(player.global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				current_state = State.IDLE
				
		State.HIT:
			velocity = Vector2.ZERO
			print(knockBack)
			knockBack = knockBack.move_toward(Vector2.ZERO, FRICTION * delta)
			print(knockBack)
			knockBack = move_and_slide(knockBack)
			current_state = pick_state([State.IDLE, State.WANDER])
			wanderAI.start_timer(rand_range(1, 2))
				
	velocity = move_and_slide(velocity)
	
func pick_state(stateList):
	stateList.shuffle()
	return stateList.pop_front()

func seek_player():
	if playerdetection.see_player():
		current_state = State.CHASE
		
func _on_Hitbox_area_entered(area):
	if area.name == "AttackHitbox":
		print(area.velocity_vector)
		knockBack = area.velocity_vector * 500
		current_state = State.HIT
		getHit()
		
		
	

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
	
func death():
	var rand_x = rand_range(-10.0, 10.0)
	var rand_y = rand_range(-5.0, 5.0)
	coin_instance.global_position = global_position - Vector2(rand_x, rand_y)
	get_tree().get_root().add_child(coin_instance)
	queue_free()

