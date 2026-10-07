class_name MagicWave
extends Node2D


@export var charge_time: float = 1.0

# 生成数量
@export var projectile_count: int = 30

# 随机散射角度
@export var angle_spread: float = 15.0

# 每颗生成间隔
@export var projectile_interval: float = 0.02


# 场景资源

# 多种飞行物
@export var projectile_scenes: Array[PackedScene]

# 魔法阵
@export var magic_circle_scene: PackedScene

# 状态

var player: Node2D

# 是否正在瞄准
var aiming: bool = true

# 锁定释放位置

var cast_position: Vector2

# 锁定释放方向

var locked_direction: Vector2
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:

	# 预览半透明

	animated_sprite.modulate.a = 0.1

# =========================
# 瞄准阶段
# =========================

func _process(_delta: float) -> void:


	if not aiming:

		return



	if player == null:

		return



	var mouse_position := get_global_mouse_position()



	var direction := player.global_position.direction_to(
		mouse_position
	)



	# MagicWave跟随玩家

	global_position = player.global_position



	# 朝向鼠标

	rotation = direction.angle()






# =========================
# 确认释放
# =========================

func Confirm() -> void:


	if not aiming:

		return



	aiming = false



	# =====================
	# 保存释放信息
	# =====================


	cast_position = global_position


	locked_direction = Vector2.RIGHT.rotated(
		rotation
	)




	# 隐藏预览

	animated_sprite.modulate.a = 0



	# 开始释放

	StartCast()





# =========================
# 技能释放流程
# =========================

func StartCast() -> void:



	# 创建魔法阵

	var circle = magic_circle_scene.instantiate()



	get_tree().current_scene.add_child(
		circle
	)



	# 固定位置

	circle.global_position = cast_position




	# 蓄力

	await get_tree().create_timer(
		charge_time
	).timeout




	print("MagicWave开始释放")




	# =====================
	# 生成飞行物
	# =====================


	for i in projectile_count:


		SpawnProjectile()



		if projectile_interval > 0:


			await get_tree().create_timer(
				projectile_interval
			).timeout





	print("Projectile生成完成")




	# 魔法阵消失

	await FadeOutCircle(circle)






# =========================
# 生成Projectile
# =========================

func SpawnProjectile() -> void:



	if projectile_scenes.is_empty():


		print("没有设置Projectile")

		return





	# 随机选择一种飞行物

	var random_scene: PackedScene = projectile_scenes.pick_random()



	var projectile = random_scene.instantiate()



	get_tree().current_scene.add_child(
		projectile
	)




	# 固定生成位置

	projectile.global_position = cast_position





	# 随机方向偏移


	var random_angle := deg_to_rad(
		randf_range(
			-angle_spread,
			angle_spread
		)
	)



	projectile.direction = locked_direction.rotated(
		random_angle
	)







# =========================
# 魔法阵淡出
# =========================

func FadeOutCircle(circle) -> void:



	if not is_instance_valid(circle):

		return




	var tween := create_tween()



	tween.tween_property(
		circle,
		"modulate:a",
		0.0,
		1.0
	)




	await tween.finished




	if is_instance_valid(circle):

		circle.queue_free()
