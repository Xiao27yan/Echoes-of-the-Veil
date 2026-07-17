class_name Enemy_State_Run extends Enemy_State

@export_category("AI")
@export var state_duration_min:float=1
@export var state_duration_max:float=1.5

@onready var after_idle_state: Enemy_State_Idle = $"../Idle"

var _timer:float =  0
var move_speed:float = 50.0 

func Enter():
	enemy.direction = enemy.DIR4.pick_random()
	_timer = randf_range(state_duration_min,state_duration_max)
	enemy.UpdateAnimation("run")

func Process(_delta:float)->Enemy_State:
	enemy.SetDirection()
	enemy.velocity = enemy.direction * move_speed
	_timer -= _delta
	if _timer<0:
		return after_idle_state
	return null
