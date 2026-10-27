class_name Player extends CharacterBody2D

const SPEED = 100.0
const JUMP_VELOCITY = -300.0
const ANIMATION_IDLE: String = "idle"
const ANIMATION_JUMP: String = "jump"
const ANIMATION_WALK: String = "walk"
const MAX_JUMP_COUNT: int = 2

@onready var animated: AnimatedSprite2D = %AnimatedSprite2D
var jump_count = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump_count = 0

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and (is_on_floor() or jump_count < MAX_JUMP_COUNT):
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	_update_animations(direction)
	move_and_slide()
	
func _update_animations(direction: float) -> void:
	if not is_on_floor():
		animated.play(ANIMATION_JUMP)
	else:
		if direction != 0:
			animated.play(ANIMATION_WALK)
			animated.flip_h = direction < 0
		else:
			animated.play(ANIMATION_IDLE)
