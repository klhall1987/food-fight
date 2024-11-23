extends Node2D

# Enemy attributes
var current_health = 100
var attack_damage = 15
var defense = 3
var max_health = 100

# Reference to the TurnManager to notify when the turn ends
var turn_manager

# Called when the scene is ready
func _ready():
	# Find and assign the TurnManager node (adjust path as necessary)
	turn_manager = get_node("/root/Scene/Level/TurnManager")

# Enemy takes damage from the player
func take_damage(amount):
	var damage_taken = max(amount - defense, 0)  # Calculate effective damage considering defense
	current_health -= damage_taken
	if current_health < 0:
		current_health = 0
	print("Enemy takes ", damage_taken, " damage. Health: ", current_health)

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
