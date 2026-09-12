class_name AI_State_Chase extends AI_State

@export var  striking_distance = 20
@onready var attack: AI_State_Attack = $"../Attack"
@onready var idle: AI_State_Idle = $"../Idle"


func _ready() -> void:
	pass # Replace with function body.


func Enter()->void:
	actor.UpdateAnimation('run')

func Process(_delta:float)->AI_State:
	if not is_instance_valid(actor.target):
		return idle
	
	var distance = actor.global_position.distance_to(actor.target.global_position)
	actor.direction = actor.global_position.direction_to(actor.target.global_position)
	actor.SetDirection()
	actor.velocity = actor.direction *actor.move_speed
	
	if distance <striking_distance and actor.attack_timer<=0:
		return attack
	
	
	return self
