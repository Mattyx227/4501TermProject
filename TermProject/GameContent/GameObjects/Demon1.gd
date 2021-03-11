extends KinematicBody2D

signal lootDrop

const MAX_SPEED = 50
const ACCELERATION = 100
const FRICTION = 5000

enum State{
	IDLE,
	WANDER,
	CHASE,
	ATTACK,
	HIT,
}

onready var health = 100
onready var playerdetection = $Detection
onready var sprite = $AnimatedSprite
onready var wanderAI = $WanderAI
var current_state = State.WANDER
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
			velocity = Vector2.ZERO
			if wanderAI.get_time_left() == 0:
				current_state = pick_state([State.IDLE, State.WANDER])
				wanderAI.start_timer(rand_range(1, 2))
				
		State.WANDER:
			seek_player()
			sprite.play("Walk")
			
			if wanderAI.get_time_left() == 0:
				current_state = pick_state([State.IDLE, State.WANDER])
				wanderAI.start_timer(rand_range(1, 2))
			
			var direction = global_position.direction_to(wanderAI.target_Pos).normalized()
			velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			sprite.flip_h = velocity.x < 0
			
			if global_position.distance_to(wanderAI.target_Pos) <= 4:
				current_state = pick_state([State.IDLE, State.WANDER])
				wanderAI.start_timer(rand_range(1, 2))
		State.ATTACK:
			sprite.play("Attack")
			$DemonHitBox/CollisionShape2D.disabled = true
			
			yield(get_tree().create_timer(0.3), "timeout")
			sprite.play("Walk")
			$DemonHitBox/CollisionShape2D.disabled = false
			current_state = State.IDLE
			
			
		State.CHASE:
			seek_player()
			sprite.play("Walk")
			sprite.flip_h = velocity.x < 0
			var player = playerdetection.player
			var directionPlayer = null
			
			if player != null:
				directionPlayer = global_position - player.global_position
				#print(directionPlayer)
				
			if player != null && (abs(directionPlayer.y) != 8 || abs(directionPlayer.x) != 8):
				var direction = global_position.direction_to(player.global_position).normalized()
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				current_state = State.IDLE
				wanderAI.start_timer(rand_range(1, 2))
			
			
				
		State.HIT:
			velocity = Vector2.ZERO
			knockBack = knockBack.move_toward(Vector2.ZERO, 200 * delta)
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
		#print(area.velocity_vector)
		knockBack = global_position + area.velocity_vector * 2000
		current_state = State.HIT
		getHit()
		
		

func attack_finished():
	current_state = State.WANDER

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



func _on_DemonHitBox_area_entered(area):
	if area.name == "PlayerHitBox":
		#print("YES")
		current_state = State.ATTACK
