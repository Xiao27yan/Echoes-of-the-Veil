class_name Dectection_Box extends Area2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var actor: Actor = $".."
@onready var chase: AI_State_Chase = $"../StateMachine/Chase"

@export var detection_range: float = 1500.0


# 当前检测到的目标
var targets: Array[CharacterBody2D] = []


func _ready() -> void:
	monitoring = false
	
	_update_detection_range()

	body_entered.connect(_on_detection_area_body_entered)
	body_exited.connect(_on_detection_area_body_exited)


# 有目标进入检测范围
func _on_detection_area_body_entered(body):

	if not _is_valid_target(body):
		return

	if body not in targets:
		targets.append(body)

	# 更新最近目标
	actor.target = _find_closest_target()

	if actor.target:
		actor.state_machine.ChangeState(chase)


# 目标离开检测范围
func _on_detection_area_body_exited(body):

	if not _is_valid_target(body):
		return

	if body in targets:
		targets.erase(body)

	# 如果离开的正好是当前目标
	if body == actor.target:

		actor.target = _find_closest_target()

		# 还有目标
		if actor.target:
			actor.state_machine.ChangeState(chase)
		else:
			actor.target = null


# 找距离最近目标
func _find_closest_target() -> CharacterBody2D:

	var closest_target: CharacterBody2D = null
	var closest_distance := INF

	for target in targets:

		# 防止目标被删除
		if not is_instance_valid(target):
			continue

		var distance = actor.global_position.distance_to(
			target.global_position
		)

		if distance < closest_distance:

			closest_distance = distance
			closest_target = target

	return closest_target


# 判断目标是否合法
func _is_valid_target(body) -> bool:

	if body is Actor or body is Player:
		return body.faction != actor.faction

	return false


func _update_detection_range():

	if collision_shape.shape is CircleShape2D:
		collision_shape.shape.radius = detection_range
