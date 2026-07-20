class_name Enemy_State_Chase extends Enemy_State


@onready var attack: Enemy_State_Attack = $"../Attack"

func _ready() -> void:
	pass # Replace with function body.


func Enter()->void:
	enemy.UpdateAnimation('run')

func Process(_delta:float)->Enemy_State:
	if enemy.player == null:
		return null
	
	var distance = enemy.global_position.distance_to(enemy.player.global_position)
	enemy.direction = enemy.global_position.direction_to(enemy.player.global_position)
	enemy.SetDirection()
	enemy.velocity = enemy.direction *enemy.move_speed
	
	if distance <20:
		return attack
	
	
	return null
