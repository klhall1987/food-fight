extends Node2D

# Define a custom signal
signal attack_finished(damage, target)

# Player attributes
var current_health = 100
var attack_damage = 20
var defense = 5
var max_health = 100

# Reference to TurnManager to notify when the turn ends
var turn_manager
var animation_sprite  # Reference to the AnimatedSprite2D
var current_animation = ""  # Track the name of the currently playing animation

# Sliding variables
var is_sliding = false
var slide_distance = 5.0  # Total distance to slide in pixels
var slide_speed = 20.0    # Speed of sliding in pixels per second
var slide_progress = 0.0  # Track how far the character has slid
var slide_direction = Vector2(1, 0)  # Slide direction (default: right)
var sliding_forward = true  # Indicates whether the character is sliding forward or back

# Called when the scene is ready
func _ready():
	# Find and assign the TurnManager node (adjust path as necessary)
	turn_manager = get_node("/root/Scene/Level/TurnManager")
	animation_sprite = $AnimatedSprite2D
	if animation_sprite:
		animation_sprite.connect("animation_finished", Callable(self, "on_animation_finished"))
	else:
		print("Error: AnimatedSprite2D not found in _ready")

# Handle player input
func _process(delta):
	if turn_manager.current_turn == turn_manager.TurnState.PLAYER_TURN and not is_sliding:
		if Input.is_action_just_pressed("attack"):
			attack()
		elif Input.is_action_just_pressed("heal"):
			heal(20)
		elif Input.is_action_just_pressed("special"):
			special_skill(turn_manager.enemy)

	# Handle sliding motion
	if is_sliding:
		var move = slide_direction * slide_speed * delta  # Calculate this frame's movement
		position += move  # Apply movement to the character
		slide_progress += move.length()  # Track distance slid

		# Handle forward and backward sliding
		if sliding_forward and slide_progress >= slide_distance:
			# Reverse direction for backward slide
			slide_direction = -slide_direction
			slide_progress = 0.0  # Reset progress for backward slide
			sliding_forward = false
		elif not sliding_forward and slide_progress >= slide_distance:
			# End sliding after backward slide
			is_sliding = false
			slide_progress = 0.0
			sliding_forward = true  # Reset for next attack

# Player takes damage
func take_damage(amount):
	var damage_taken = max(amount - defense, 0)
	current_health -= damage_taken
	current_health = max(current_health, 0)
	print("Player takes ", damage_taken, " damage. Health: ", current_health)

# Player attacks the enemy
func attack():
	if not is_sliding:  # Prevent sliding during another slide
		current_animation = "attack"
		animation_sprite.play(current_animation)  # Play attack animation

		# Start sliding motion
		is_sliding = true
		slide_progress = 0.0
		slide_direction = Vector2(1, 0)  # Adjust as needed (e.g., Vector2(-1, 0) for left)
		sliding_forward = true  # Start with forward slide

# Example: Player heals
func heal(amount):
	current_health += amount
	current_health = min(current_health, max_health)
	print("Player heals ", amount, " Health: ", current_health)
	turn_manager.end_turn()

# Example: Special skill
func special_skill(enemy):
	print("Player uses special skill!")
	var special_damage = attack_damage * 1.5
	enemy.take_damage(special_damage)
	turn_manager.end_turn()

# Callback for when an animation finishes
func on_animation_finished():
	if current_animation == "attack":
		print("Attack animation finished!")
		emit_signal("attack_finished", attack_damage, turn_manager.enemy)  # Emit signal
		animation_sprite.play("idle")
		current_animation = ""  # Reset animation
		turn_manager.end_turn()
