extends Node

var player_turn = true  # Tracks whose turn it is
var player  # Reference to player character
var enemy   # Reference to enemy character

func _ready():
	player = $Characters/PlayerCharacter  # Adjust paths as needed
	enemy = $Characters/EnemyCharacter
	start_turn()

func start_turn():
	if player_turn:
		print("Player's turn")
		# Enable UI or player input for action selection
	else:
		print("Enemy's turn")
		await get_tree().create_timer(1).timeout  # Simulate enemy thinking time
		enemy_turn()

func end_turn():
	player_turn = !player_turn  # Switch turn
	start_turn()

func player_attack():
	enemy.take_damage(player.attack_damage)
	print("Enemy Health: ", enemy.current_health)
	end_turn()

func enemy_turn():
	player.take_damage(enemy.attack_damage)
	print("Player Health: ", player.current_health)
	end_turn()
