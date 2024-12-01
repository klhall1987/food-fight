extends Node2D

# Enemy attributes
var current_health = 100
var attack_damage = 15
var defense = 3
var max_health = 100

# Reference to the TurnManager to notify when the turn ends
var turn_manager

# Sliding variables
var is_sliding = false
var slide_distance = 10.0  # Total distance to slide in pixels
var slide_speed = 20.0     # Speed of sliding in pixels per second
var slide_progress = 0.0   # Track how far the enemy has slid
var slide_direction = Vector2(1, 0)  # Initial direction of sliding (forward)

# Starting position to return after sliding
var original_position = Vector2()

# Called when the scene is ready
func _ready():
	# Find and assign the TurnManager node (adjust path as necessary)
	turn_manager = get_node("/root/Scene/Level/TurnManager")
	original_position = position  # Save the original position for sliding back
	# Connect to the player's attack_finished signal
	var player_character = get_node("/root/Scene/Level/Characters/Player")  # Adjust the path if needed
	if player_character:
		player_character.connect("attack_finished", Callable(self, "_on_player_attack_finished"))

# Enemy takes damage from the player
func take_damage(amount):
	if is_sliding: 
		return  # Prevent multiple slides at the same time
	
	var damage_taken = max(amount - defense, 0)  # Calculate effective damage considering defense
	current_health -= damage_taken
	if current_health < 0:
		current_health = 0
	print("Enemy takes ", damage_taken, " damage. Health: ", current_health)

	# Start sliding motion
	is_sliding = true
	slide_progress = 0.0
	slide_direction = Vector2(1, 0)  # Set the direction to forward for the first slide

# Enemy attacks the player
func attack(player):
	print("Enemy attacks!")
	player.take_damage(attack_damage)
	# End the enemy's turn
	turn_manager.end_turn()

# Example of an enemy heal action (optional)
func heal(amount):
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	print("Enemy heals ", amount, " Health: ", current_health)
	turn_manager.end_turn()

# Example of a special enemy skill (optional)
func special_skill(player):
	print("Enemy uses special skill!")
	var special_damage = attack_damage * 2  # Double damage for example
	player.take_damage(special_damage)
	turn_manager.end_turn()

# Enemy's logic for deciding what to do on its turn (basic behavior)
func enemy_turn(player):
	print("Enemy's turn starts.")
	# Simple AI: attack if the enemy's health is above 20, else heal
	if current_health > 20:
		attack(player)  # Attack the player
	else:
		heal(15)  # Heal the enemy

# Handle the player's attack_finished signal
func _on_player_attack_finished(damage, target):
	# Ensure this enemy is the target
	if target == self:
		take_damage(damage)

# Handle sliding motion
func _process(delta):
	if is_sliding:
		var move = slide_direction * slide_speed * delta  # Calculate this frame's movement
		var target_position = position + move            # Predict the next position

		# Check if the movement would overshoot the target
		if slide_direction.dot(original_position - position) > 0 and target_position.distance_to(original_position) <= slide_distance * delta:
			position = original_position  # Snap to original position
			is_sliding = false  # Stop sliding
		else:
			position = target_position  # Apply movement
			slide_progress += move.length()  # Update slide progress

			# Reverse direction if past the sliding distance
			if slide_progress >= slide_distance:
				slide_direction = (original_position - position).normalized()
				slide_progress = 0.0  # Reset slide progress for reverse motion
