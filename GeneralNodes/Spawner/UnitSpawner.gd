class_name UnitSpawner 
extends Node2D 


@export var spawn_list:Array[UnitSpawnData] 
@export var spawn_points:Array[Node2D] 

# 记录最近使用过的出生点
var last_spawn_points:Array[Node2D] = []


func _ready():

	await get_tree().process_frame

	StartSpawn()


func StartSpawn():

	for data in spawn_list:

		for i in data.amount:

			Spawn(data)

			await get_tree().create_timer(data.interval).timeout


func Spawn(data:UnitSpawnData):

	var valid_spawn_points:Array[Node2D] = []

	for point in spawn_points:
		if point != null:
			valid_spawn_points.append(point)

	if valid_spawn_points.is_empty():
		print("错误：没有有效的 SpawnPoint")
		return

	# 排除最近使用过的出生点
	var available_spawn_points = valid_spawn_points.filter(
		func(point):
			return point not in last_spawn_points
	)

	# 如果所有出生点都被记录了，就重新允许使用
	if available_spawn_points.is_empty():
		available_spawn_points = valid_spawn_points

	# 从剩余出生点中随机选择
	var spawn_point = available_spawn_points.pick_random()

	# 记录这次使用的出生点
	last_spawn_points.append(spawn_point)

	# 只保留最近 3 个出生点
	if last_spawn_points.size() > 3:
		last_spawn_points.pop_front()

	# 创建单位
	var unit = data.unit_scene.instantiate()

	get_parent().add_child(unit)

	# 在出生点附近随机一点位置
	unit.global_position = spawn_point.global_position + Vector2(
		randf_range(-50,50),
		randf_range(-50,50)
	)
