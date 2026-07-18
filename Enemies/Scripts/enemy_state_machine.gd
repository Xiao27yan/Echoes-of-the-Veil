class_name Enemy_State_Machine extends Node

var states:Array=[]
var prev_state:Enemy_State
var current_state:Enemy_State


func _ready() -> void:
	pass # Replace with function body.


# Process state logic every frame and switch states when needed.
func _process(delta:float) -> void:
	ChangeState(current_state.Process(delta))
	pass


func _physics_process(delta:float) -> void:
	ChangeState(current_state.Physics(delta))
	pass
	

#func _unhandled_input(event) -> void:
	#ChangeState(current_state.HandleInput(event))


func Initialize(_enemy:Enemy)->void:
	states = []
	for c in get_children():
		if c is Enemy_State:
			c.enemy = _enemy
			c.enemy_state_machine = self
			states.append(c)
			c.Init()
	
	if states.size() == 0:
		return	
	
	ChangeState(states[0])
	process_mode = Node.PROCESS_MODE_INHERIT
	pass


func ChangeState(new_state:Enemy_State)->void:
	if new_state == null || new_state == current_state:
		return
	
	if current_state:
		current_state.Exit()
	prev_state = current_state
	current_state = new_state
	current_state.Enter()
	pass
