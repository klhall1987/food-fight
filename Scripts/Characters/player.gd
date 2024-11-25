extends Node2D

# Player attributes
var current_health = 100
var attack_damage = 20
var defense = 5
var max_health = 100

# Reference to TurnManager to notify when the turn ends
var turn_manager
var animation_sprite  # Reference to the AnimatedSprite2D
var current_animation = ""  # Track the name of the currently playing animation

# Called when the scene is ready
func _ready():
	# Find and assign the TurnManager node (adjust path as necessary)
	turn_manager = get_node("/root/Scene/Level/TurnManager")
	animation_sprite = $AnimatedSprite2D
	if animation_sprite:
		animation_sprite.connect("animation_finished", Callable(self, "on_animation_finished"))
		print("Signal connected in _on_tree_entered")
	else:
		print("Error: AnimatedSprite2D not found in _on_tree_entered")


# Handle player input
func _process(_delta):
	if turn_manager.current_turn == turn_manager.TurnState.PLAYER_TURN:  # Use TurnManager's TurnState
		if Input.is_action_just_pressed("attack"):  # Check if the 'attack' button is pressed
			attack(turn_manager.enemy)  # Attack the enemy
		elif Input.is_action_just_pressed("heal"):  # Example: If the player has heal mapped
			heal(20)  # Heal the player
		elif Input.is_action_just_pressed("special"):  # Special skill mapped
			special_skill(turn_manager.enemy)

# Player takes damage from the enemy
func take_damage(amount):
	var damage_taken = max(amount - defense, 0)  # Calculate effective damage considering defense
	current_health -= damage_taken
	if current_health < 0:
		current_health = 0
	print("Player takes ", damage_taken, " damage. Health: ", current_health)

# Player attacks the enemy
func attack(enemy):
	print(animation_sprite)
	current_animation = "attack"  # Set the current animation name
	animation_sprite.play(current_animation)  # Play attack animation
	enemy.take_damage(attack_damage)

# Example of a player heal action (optional)
func heal(amount):
	current_health += amount
	if current_health > max_health:
		current_health = max_health
	print("Player heals ", amount, " Health: ", current_health)
	turn_manager.end_turn()  # End the player's turn

# Example of a special skill (optional)
func special_skill(enemy):
	print("Player uses special skill!")
	var special_damage = attack_damage * 1.5  # Deal more damage for example
	enemy.take_damage(special_damage)
	turn_manager.end_turn()  # End the player's turn

# Callback method for when an animation finishes
# Callback for when any animation finishes
func on_animation_finished():
	if current_animation == "attack":
		print("Attack animation finished!")
		animation_sprite.play("idle")  # Return to idle animation
		current_animation = ""  # Reset the current animation
		turn_manager.end_turn()  # End the player's turn
	else:
		print("Other animation finished:", current_animation)  # Play idle animation after the attack finishes
