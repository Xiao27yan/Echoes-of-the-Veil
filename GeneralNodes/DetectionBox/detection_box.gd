class_name friend_Dectection_Box extends Area2D

@onready var actor:Actor = $".."

@onready var chase: AI_State_Chase = $"../StateMachine/Chase"

func _ready() -> void:
	
	body_entered.connect(_on_detection_area_body_entered)
	body_exited.connect(_on_detection_area_body_exited)
	pass

func _process(delta: float) -> void:
#	如果无效的话
	if not is_instance_valid(actor.target):
		actor.target = _find_target()
		if actor.target != null:
			actor.state_machine.ChangeState(chase)
	pass
	
func _on_detection_area_body_entered(body):
	if _is_valid_target(body):
		actor.target = body
		actor.state_machine.ChangeState(chase)

func _on_detection_area_body_exited(body):

	if body == actor.target:
		actor.target = _find_target()
		if actor.target != null:
			actor.state_machine.ChangeState(chase)

func _find_target() -> CharacterBody2D:
#	这个方法会返回所有在区域中的对象
	for body in get_overlapping_bodies():
		if _is_valid_target(body):
			return body
	return null

#检测是否是敌对目标
func _is_valid_target(body)->bool:

	if body is Actor:

		return body.faction != actor.faction

	return false
