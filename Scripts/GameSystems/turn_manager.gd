extends Node

enum TurnState { PLAYER_TURN, ENEMY_TURN }
var current_turn = TurnState.PLAYER_TURN

var player
var enemy

func _ready():
	player = get_node("../Characters/Player")  # Access Player node relative to TurnManager
	enemy = get_node("../Characters/Enemy")    # Access Enemy node relative to TurnManager
	start_turn()

func start_turn():
	match current_turn:
		TurnState.PLAYER_TURN:
			print("Player's turn")
			# Enable player input or show UI for action selection
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
	check_game_over()
	end_turn()

func enemy_turn():
	print("Enemy attacks!")
	player.take_damage(enemy.attack_damage)
	print("Player Health: ", player.current_health)
	check_game_over()
	end_turn()

func check_game_over():
	if player.current_health <= 0:
		print("Game Over! Enemy Wins!")
		get_tree().paused = true
	elif enemy.current_health <= 0:
		print("You Win!")
		get_tree().paused = true
