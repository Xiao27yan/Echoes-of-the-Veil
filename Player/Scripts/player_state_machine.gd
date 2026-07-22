class_name PlayerStateMachine extends Node

var states:Array=[]
var prev_state:State
var current_state:State


func _ready() -> void:

	pass # Replace with function body.

# 处理每一帧的逻辑 看是否需要切换状态
func _process(delta:float) -> void:
	ChangeState(current_state.Process(delta))
	pass

func _physics_process(delta:float) -> void:
	ChangeState(current_state.Physics(delta))
	pass
	
func _unhandled_input(event) -> void:
	ChangeState(current_state.HandleInput(event))

func Initialize(_player:Player)->void:
	states = []

	for c in get_children():
		if c is  State:
			states.append(c)
			c.Init()
		states[0].player = _player
		states[0].state_machine = self
		
	if states.size() == 0:
			return
			
	ChangeState(states[0])
	process_mode = Node.PROCESS_MODE_INHERIT
	pass

func ChangeState(new_state:State)->void:
	if new_state == null || new_state == current_state:
		return
	
	if current_state:
		current_state.Exit()
	prev_state = current_state
	current_state = new_state
	current_state.Enter()
	print('player进入',new_state.name)

	pass
