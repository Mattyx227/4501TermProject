extends KinematicBody2D
signal hit 


const MAX_SPEED = 40
const ACCELERATION = 30
const FRICTION = 300

var velocity = Vector2.ZERO
var coin = 0


onready var state = MOVE
onready var animationRouge = $RogueAnimation
onready var attackHitBox = $Position2D/AttackHitbox

func _ready():
	randomize()
	attackHitBox.velocity_vector = Vector2.LEFT
	animationRouge.set_speed_scale(1)

enum {
	MOVE,
	ATTACK
}


func addCoin():
	coin += 1
	print(coin)

func _process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state()
	
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state()
	
	if Input.is_action_just_pressed("Test"):
		animationRouge.set_speed_scale(2)
			
func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		attackHitBox.velocity_vector  = Vector2(input_vector.x, 0)
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
