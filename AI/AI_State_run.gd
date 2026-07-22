class_name AI_State_Run extends AI_State

@export_category("AI")
@export var state_duration_min:float=1
@export var state_duration_max:float=1.5

@onready var hurt_box: HurtBox = $"../../HurtBox"
@onready var after_idle_state: AI_State_Idle = $"../Idle"

var _timer:float =  0


func Init()->void:
	pass


func Enter():
	actor.direction = actor.DIR4.pick_random()
	actor.SetDirection()
	_timer = randf_range(state_duration_min,state_duration_max)
	actor.UpdateAnimation("run")

func Process(_delta:float)->AI_State:
	actor.SetDirection()
	actor.velocity = actor.direction * actor.move_speed
	_timer -= _delta
	if _timer<0:
		return after_idle_state
	return null
