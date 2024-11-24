extends Node

enum TurnState { PLAYER_TURN, ENEMY_TURN }
var current_turn = TurnState.PLAYER_TURN

var player
var enemy
var player_name_label
var enemy_name_label
var player_health_bar
var enemy_health_bar

func _ready():
	# Access player and enemy nodes
	player = get_node("../Characters/Player")  # Path to the Player node
	enemy = get_node("../Characters/Enemy")    # Path to the Enemy node

	# Access the UI labels
	player_name_label = get_node("/root/Scene/Level/UI/Player/Label")  # Player's name label
	enemy_name_label = get_node("/root/Scene/Level/UI/Enemy/Label")    # Enemy's name label

	# Access the ProgressBars
	player_health_bar = get_node("/root/Scene/Level/UI/Player/HealthBar")
	enemy_health_bar = get_node("/root/Scene/Level/UI/Enemy/HealthBar")

	# Set names on the labels
	player_name_label.text = player.name
	enemy_name_label.text = enemy.name

	# Set initial health bar values
	player_health_bar.max_value = player.max_health
	player_health_bar.value = player.current_health
	enemy_health_bar.max_value = enemy.max_health
	enemy_health_bar.value = enemy.current_health

	start_turn()

func start_turn():
	match current_turn:
		TurnState.PLAYER_TURN:
			print("Player's turn")
		TurnState.ENEMY_TURN:
			print("Enemy's turn")
			await get_tree().create_timer(1).timeout  # Simulate enemy thinking time
			enemy_turn()

func end_turn():
	if current_turn == TurnState.PLAYER_TURN:
		current_turn = TurnState.ENEMY_TURN
	else:
		current_turn = TurnState.PLAYER_TURN
	start_turn()

func player_attack():
	print("Player attacks!")
	enemy.take_damage(player.attack_damage)
	print("Enemy Health: ", enemy.current_health)
	update_health_bars()  # Update health bars after attack
	check_game_over()
	end_turn()

func enemy_turn():
	print("Enemy attacks!")
	player.take_damage(enemy.attack_damage)
	print("Player Health: ", player.current_health)
	update_health_bars()  # Update health bars after enemy attack
	check_game_over()
	end_turn()

func check_game_over():
	if player.current_health <= 0:
		print("Game Over! Enemy Wins!")
		get_tree().paused = true
	elif enemy.current_health <= 0:
		print("You Win!")
		get_tree().paused = true

# Function to update health bars
func update_health_bars():
	player_health_bar.value = player.current_health  # Update player health bar
	enemy_health_bar.value = enemy.current_health    # Update enemy health bar
