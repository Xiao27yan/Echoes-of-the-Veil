class_name Enemy_State_Attack extends Enemy_State
var attacking:bool = false


@onready var chase: Enemy_State_Chase = $"../Chase"
@onready var idle: Enemy_State_Idle = $"../Idle"
@onready var run: Enemy_State_Run = $"../Run"


func Enter()->void:
	attacking = true
	enemy.hurt_box.monitoring = true
	enemy.UpdateAnimation('attack')
	if not enemy.sprite.animation_finished.is_connected(EndAttack):
		enemy.sprite.animation_finished.connect(EndAttack)
	
func Process(_delta:float)->Enemy_State:
	enemy.velocity -= enemy.decelerate_speed*_delta*enemy.velocity
	if attacking == false:
		if enemy.player != null:
			return chase
		if enemy.direction == Vector2.ZERO:
			return idle
		else:
			return run
	return null
	


func EndAttack()->void:
	attacking  =  false
	enemy.hurt_box.monitoring = false
