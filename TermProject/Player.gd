extends KinematicBody2D
signal hit 
signal health_changed
signal maxhealth_changed
signal level_changed


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
var strength : int
var tenacity : int
var magic : int
var swiftness : int
var maxEXP : int
var currentEXP : int
var level : int	
var coin : int
var skillpoint : int

var velocity = Vector2.ZERO
var swordDirection = 0
var knockBack = Vector2.ZERO
var alive = true
var respawnLoc


onready var state = MOVE
onready var animationRouge = $RogueAnimation
onready var attackHitBox = $Position2D/AttackHitbox
onready var sprite = $Rogue
onready var UI = $UI/Control
onready var hitbox = $PlayerHitBox
onready var world = $"../.."


func _ready():
	randomize()
	attackHitBox.velocity_vector = Vector2.LEFT
	animationRouge.set_speed_scale(1)
	initializeStats(starting_stats)
	updateStats()
	respawnLoc = self.position
	
enum {
	MOVE,
	ATTACK,
	HIT,
	DEATH
}
func level_up():
	level += 1
	skillpoint += 1
	currentEXP = currentEXP - maxEXP
	maxEXP = getEXP_required(level + 1)
	
func respawn():
	world.modulate = Color(1, 1, 1)
	currentEXP = currentEXP * 0.25
	coin = coin * 0.9
	health = max_health
	print(health)
	animationRouge.play_backwards("Death")
	self.position = respawnLoc
	alive = true
	state = MOVE

	
func getEXP_required(level):
	return round(pow(level, 2) + level * 15) +10
	
func increase_EXP(amount):
	currentEXP += amount
	while currentEXP >= maxEXP: 
		level_up()
	
	print("CUrrent Level:" + str(level) + "Increase EXP by" + str(amount) + ", new EXP is:" + str(currentEXP) + "Max EXP is:" + str(maxEXP))

func updateStats():
	maxEXP = getEXP_required(level + 1)
	attack = 5 + 2*strength
	defense = 5 + tenacity
	max_health = 10 + 5*tenacity
	
func toggleUI():
		if UI.visible == true:
			UI.visible = false
		else:
			UI.visible = true

func addCoin():
	coin += 1
	print(coin)

func death():
	alive = false
	animationRouge.play("Death")
	world.modulate = Color(0.8, 0.5, 0.5)


func _process(delta):
	if alive == true:
		updateStats()
		UI.updateUI()
		attackHitBox.damage = attack
		match state:
			MOVE:
				move_state(delta)
			ATTACK:
				attack_state()
			HIT:
				getHit()
			DEATH:
				death()
		
		if Input.is_action_just_pressed("Test"):
			strength += 1
			tenacity += 1
			#increase_EXP(100)
			
		if Input.is_action_just_pressed("UI"):
			toggleUI()
			
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
	
	if health <= 0:
		state = DEATH

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
		


func initializeStats(starting_stats):
	max_health = starting_stats.max_health
	max_mana = starting_stats.max_mana
	health = starting_stats.health
	speed = starting_stats.speed
	defense = starting_stats.defense
	attack = starting_stats.attack
	strength = starting_stats.strength
	tenacity = starting_stats.tenacity
	magic = starting_stats.magic
	swiftness = starting_stats.swiftness
	maxEXP = starting_stats.maxEXP
	currentEXP = starting_stats.currentEXP
	level = starting_stats.level
	coin = starting_stats.coin
	skillpoint = starting_stats.skillpoint



