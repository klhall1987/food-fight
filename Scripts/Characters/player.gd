extends Node2D

# Player attributes
var current_health = 100
var attack_damage = 20
var defense = 5
var max_health = 100

# Reference to TurnManager to notify when the turn ends
var turn_manager

# Called when the scene is ready
func _ready():
	# Find and assign the TurnManager node (adjust path as necessary)
	turn_manager = get_node("/root/Scene/Level/TurnManager")

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
	print("Player attacks!")
	enemy.take_damage(attack_damage)
	turn_manager.end_turn()  # End the player's turn

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
