extends KinematicBody2D
signal hit 
signal health_changed


const MAX_SPEED = 60
const ACCELERATION = 30
const FRICTION = 300

export var starting_stats : Resource
var health : int
var mana : int
var max_health : int 
var max_mana : int 
var attack : int
var defense : int
var speed : int

var velocity = Vector2.ZERO
var coin = 0
var swordDirection = 0
var knockBack = Vector2.ZERO


onready var state = MOVE
onready var animationRouge = $RogueAnimation
onready var attackHitBox = $Position2D/AttackHitbox
onready var sprite = $Rogue
#onready var hpBar = get_parent().get_parent().get_node("CanvasLayer/Control")


func _ready():
	randomize()
	attackHitBox.velocity_vector = Vector2.LEFT
	animationRouge.set_speed_scale(1)
	initializeStats(starting_stats)
	#hpBar.initHP()
	
enum {
	MOVE,
	ATTACK,
	HIT
}


func addCoin():
	coin += 1
	print(coin)

func _process(delta):
	attackHitBox.damage = attack
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state()
		HIT:
			getHit()
	
	if Input.is_action_just_pressed("Test"):
		animationRouge.set_speed_scale(2)
	
			
func move_state(delta):
	var input_vector = Vector2.ZERO
	if Input.get_action_strength("ui_right") == 1:
		swordDirection = 1
	else:
		swordDirection = -1
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		attackHitBox.velocity_vector  = Vector2(swordDirection, 0)
		if input_vector.x > 0:
			$Rogue.flip_h = false
			$Position2D.scale.x = 1
			animationRouge.play("Walk")
		elif input_vector.x < 0:
			$Rogue.flip_h = true
			$Position2D.scale.x = -1
			animationRouge.play("Walk")
		elif input_vector.y != 0:
			animationRouge.play("Walk")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION)
		velocity = velocity.clamped(MAX_SPEED)
	else:
		animationRouge.play("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	velocity = move_and_slide(velocity)
	
	if Input.is_action_just_pressed("Attack"):
		state = ATTACK

func attack_state():
	velocity = Vector2.ZERO
	animationRouge.play("Attack")


func attack_finished():
	state = MOVE

func getHit():
	knockBack = knockBack.move_toward(Vector2.ZERO, 50)
	knockBack = move_and_slide(knockBack)
	sprite.set_modulate(Color( 0.65, 0.16, 0.16, 1))
	var t = Timer.new()
	t.set_wait_time(0.2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	sprite.set_modulate(Color( 1, 1, 1, 1))
	t.queue_free()
	state = MOVE
	#Tranisiton.change_scene()

func _on_PlayerHitBox_area_entered(area):
	if area.name == "DemonHitBox" || area.name == "SkeletonHitBox":
		emit_signal("health_changed",  -(area.damage - defense))
#		hpBar.health_update(health, area.damage - defense)
		health -= (area.damage - defense)
		knockBack =  (global_position - area.get_parent().position).normalized()*250
		state = HIT
		print(health)
		
	
		

func initializeStats(starting_stats):
	max_health = starting_stats.max_health
	max_mana = starting_stats.max_mana
	health = starting_stats.max_health
	speed = starting_stats.speed
	defense = starting_stats.defense
	attack = starting_stats.attack

	
		
