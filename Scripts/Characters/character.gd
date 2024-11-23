extends Node2D

var max_health = 100
var current_health = max_health
var attack_damage = 20

func take_damage(damage):
	current_health -= damage
	current_health = max(current_health, 0)
	if current_health == 0:
		die()

func die():
	print(name + " has been defeated!")
	queue_free()  # Remove from the scene or trigger defeat sequence
