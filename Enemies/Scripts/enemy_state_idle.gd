class_name Enemy_State_Idle extends Enemy_State

@export_category("AI")
@export var state_duration_min:float=0.4
@export var state_duration_max:float=1.2

@onready var after_idle_state:Enemy_State = $"../Run"

var _timer:float  = 0.0

func Init()->void:
	pass

func Enter()->void:
	enemy.velocity = Vector2.ZERO
	_timer = randf_range(state_duration_min,state_duration_max)
	enemy.UpdateAnimation("idle")
	pass
	
func Process(_delta:float)->Enemy_State:
	_timer -= _delta
	if _timer <0:
		return after_idle_state
	return null
	

	
