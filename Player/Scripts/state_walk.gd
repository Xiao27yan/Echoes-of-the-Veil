class_name State_Walk extends State


@export var run_speed:float	 = 400.0

@onready var idle:State_Idle = $"../Idle"
@onready var attack: State_Attack = $"../Attack"


func Enter()->void:
	player.UpdateAnimation("walk")
	pass

func Process(_delta:float)->State:
	if player.direction == Vector2.ZERO:
		return idle

	if Input.is_action_pressed("run"):
		player.velocity = player.direction * run_speed
		if player.SetDirection():
			player.UpdateAnimation("run")
	else:
		player.velocity = player.direction * player.move_speed
		if player.SetDirection():
			player.UpdateAnimation("walk")
	
	return null

func HandleInput(_event:InputEvent)->State:
	
	print("收到输入：", _event)

	if _event.is_action_pressed("attack"):
		return attack
		
	return null
