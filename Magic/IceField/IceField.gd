class_name IceField
extends Node2D


# =====================
# 冰晶设置
# =====================

@export var crystal_scene: PackedScene


# 冰晶数量

@export var crystal_count: int = 100


# 冰晶生成范围

@export var field_radius_x: float = 120.0

@export var field_radius_y: float = 60.0


# 冰晶生成间隔

@export var crystal_spawn_interval: float = 0.01



# =====================
# 基础设置
# =====================

@export var cast_range: float = 500.0



# =====================
# 持续时间
# =====================

@export var duration: float = 10.0


# 淡出时间

@export var fade_time: float = 2.0



# =====================
# 状态
# =====================

var player: Node2D

var aiming: bool = true


# 锁定位置

var cast_position: Vector2



@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var crystal_container: Node2D = $CrystalContainer





func _ready() -> void:

	# 预览透明

	animated_sprite.modulate.a = 0.5






# =====================
# 瞄准阶段
# =====================

func _process(_delta):


	if not aiming:

		return


	if player == null:

		return



	var mouse_position = get_global_mouse_position()



	var direction = player.global_position.direction_to(
		mouse_position
	)



	var distance = player.global_position.distance_to(
		mouse_position
	)



	distance = min(
		distance,
		cast_range
	)



	global_position = player.global_position + direction * distance







# =====================
# 确认释放
# =====================

func Confirm() -> void:


	if not aiming:

		return



	aiming = false



	# 锁定最终位置

	cast_position = global_position



	print(
		"冰霜领域释放位置:",
		cast_position
	)



	# 恢复正常显示

	animated_sprite.modulate.a = 1.0



	StartField()







# =====================
# 开始冰霜领域
# =====================

func StartField() -> void:


	print("冰霜领域启动")



	# 生成冰晶

	SpawnCrystals()



	# 等待持续时间

	await get_tree().create_timer(
		duration
	).timeout



	# 开始消散

	FadeOut()







# =====================
# 生成冰晶
# =====================

func SpawnCrystals() -> void:


	if crystal_scene == null:


		print("没有设置冰晶场景")


		return



	for i in crystal_count:


		var crystal = crystal_scene.instantiate()



		crystal_container.add_child(
			crystal
		)



		# 随机位置

		crystal.position = GetRandomPointInField()



		await get_tree().create_timer(
			crystal_spawn_interval
		).timeout







# =====================
# 获取随机位置
# =====================

func GetRandomPointInField() -> Vector2:


	var x = randf_range(
		-field_radius_x,
		field_radius_x
	)



	var y = randf_range(
		-field_radius_y,
		field_radius_y
	)



	return Vector2(
		x,
		y
	)







# =====================
# 淡出消失
# =====================

func FadeOut() -> void:


	print("冰霜领域消散")



	var tween = create_tween()



	tween.tween_property(
		self,
		"modulate:a",
		0.0,
		fade_time
	)



	await tween.finished



	queue_free()
