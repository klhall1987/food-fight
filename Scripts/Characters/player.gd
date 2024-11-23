extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var speed = 50
var jump_velocity = -200
var gravity = 1000

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Movement input
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		direction.x = -1
	elif Input.is_action_pressed("move_right"):
		direction.x = 1

	velocity.x = direction.x * speed

	# Jump input
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		sprite.play("jump")  # Show jump frame

	# Handle animations
	if is_on_floor():
		if direction.x < 0:  # Moving left
			sprite.play("walk_left")
		elif direction.x > 0:  # Moving right
			sprite.play("walk_right")
		else:  # Not moving horizontally
			sprite.play("idle")

	# Apply movement
	move_and_slide()
