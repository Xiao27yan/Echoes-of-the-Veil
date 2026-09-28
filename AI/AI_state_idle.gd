class_name AI_State_Idle extends AI_State

@export_category("AI")
@export var state_duration_min:float=0.4
@export var state_duration_max:float=1.2

@onready var after_idle_state: AI_State_Run = $"../Run"
#@onready var after_idle_state: AI_State_Idle = $"."




var _timer:float  = 0.0

func Init()->void:
	pass

func Enter()->void:
	actor.velocity = Vector2.ZERO
	_timer = randf_range(state_duration_min,state_duration_max)
	actor.UpdateAnimation("idle")
	pass
	
func Process(_delta:float)->AI_State:
	_timer -= _delta
	if _timer <0:
		return after_idle_state
	return null
	

	
