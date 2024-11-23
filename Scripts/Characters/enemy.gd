extends CharacterBody2D

var speed = 100
var points = [Vector2(100, 0), Vector2(-100, 0)]  # Movement points
var current_point = 0

func _physics_process(_delta):
	var target = points[current_point]
	velocity = (target.normalized() * speed)
	
	move_and_slide()
	
	# Change direction when reaching the point
	if position.distance_to(target) < 10:
		current_point = (current_point + 1) % points.size()
