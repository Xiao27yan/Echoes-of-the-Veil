class_name Dectection_Box extends Area2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var actor:Actor = $".."
@onready var chase: AI_State_Chase = $"../StateMachine/Chase"
@export var detection_range: float = 1500.0

func _ready() -> void:
	_update_detection_range()
	body_entered.connect(_on_detection_area_body_entered)
	body_exited.connect(_on_detection_area_body_exited)
	pass

func _process(delta: float) -> void:
#	如果无效的话
	if not is_instance_valid(actor.target):
		actor.target = _find_target()
		if actor.target != null:
			print(actor.target.name)
			actor.state_machine.ChangeState(chase)
		else:
			print('no target')
	pass
	
func _on_detection_area_body_entered(body):
	if actor.target != null:
		return
	
	if _is_valid_target(body) :
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
	
func _update_detection_range():

	if collision_shape.shape is CircleShape2D:

		collision_shape.shape.radius = detection_range
