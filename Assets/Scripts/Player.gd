extends KinematicBody

enum {IDLE, RUN, JUMP, HURT, DEAD}
var state = IDLE

#Global Constant Variables
const GRAVITY = 6

#Jump Variables
const JUMP_FORCE = 9
const JUMP_MAX = 1
var jump_count = 1

#Horizontal Movement Variables
const SPEED_RUN = 10
var move_speed = SPEED_RUN
var velocity = Vector3(0,0,0)

export (NodePath) var level_root

#This function handles changing states
func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			$Anim.play("Idle")
		RUN:
			if $Anim.current_animation != "Run":
				$Anim.play("Run")
			if velocity.x > 0:
				$Sprite.flip_h = false
			elif velocity.x < 0:
				$Sprite.flip_h = true
		JUMP:
			pass
		HURT:
			pass
		DEAD:
			pass

func _physics_process(delta):
	velocity.y -= GRAVITY * delta
	if velocity.y < 0:
		velocity.y -= 8 * delta
	velocity.x = 0
	
	control_process()
	
	move_and_slide(velocity, Vector3(0,1,0))
	
	if is_on_floor():
		jump_count = JUMP_MAX

func control_process():
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	
	if right:
		velocity.x = move_speed
	if left:
		velocity.x = -move_speed
	
	if jump and jump_count > 0:
		jump_count -= 1
		velocity.y += JUMP_FORCE
	
	#Switches state between Run and Idle
	if velocity.x != 0:
		change_state(RUN)
	if velocity == Vector3(0,0,0):
		change_state(IDLE)
	


