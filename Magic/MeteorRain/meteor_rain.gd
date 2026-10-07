class_name MeteorRain
extends Node2D


@export var cast_range: float = 350.0
@export var charge_time: float = 1.0


# 陨石
@export var meteor_scene: PackedScene
@export var meteor_count: int = 100
@export var meteor_interval: float = 0.05

# 法阵椭圆范围
@export var meteor_area_radius_x: float = 130.0
@export var meteor_area_radius_y: float = 50.0

# 给陨石 HurtBox 留出的安全距离
@export var meteor_safe_margin: float = 40.0


var player: Node2D
var aiming: bool = true
var casting: bool = false


@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	animated_sprite.play("cast")
	animated_sprite.modulate.a = 0.5


func _process(_delta: float) -> void:
	if not aiming:
		return

	if player == null:
		return

#让魔法阵随鼠标
	var mouse_position := get_global_mouse_position()

	var direction := player.global_position.direction_to(mouse_position)

	var distance := player.global_position.distance_to(mouse_position)

	distance = min(distance, cast_range)

	global_position = player.global_position + direction * distance


func Confirm() -> void:
	if not aiming:
		return

	aiming = false
	casting = true

	animated_sprite.modulate.a = 1.0

	print("魔法阵锁定：", global_position)

	await get_tree().create_timer(charge_time).timeout

	casting = false

	# 等待所有陨石全部生成
	await SpawnMeteorRain()

	# 所有陨石生成完成后，法阵缓慢消失
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(
		animated_sprite,
		"modulate:a",
		0.0,
		2.0
	)

func SpawnMeteorRain() -> void:
	for i in meteor_count:
		SpawnMeteor()

		await get_tree().create_timer(meteor_interval).timeout


func SpawnMeteor() -> void:
	var meteor := meteor_scene.instantiate()

	get_tree().current_scene.add_child(meteor)

	# 陨石 HurtBox 的安全范围
	var safe_x := meteor_area_radius_x - meteor_safe_margin
	var safe_y := meteor_area_radius_y - meteor_safe_margin

	# 防止安全范围变成负数
	safe_x = max(safe_x, 0.0)
	safe_y = max(safe_y, 0.0)

	# 在椭圆内部随机生成
	var random_angle := randf() * TAU
	var random_radius := sqrt(randf())

	var random_offset := Vector2(
		cos(random_angle) * safe_x * random_radius,
		sin(random_angle) * safe_y * random_radius
	)

	var target_position := global_position + random_offset

	meteor.StartFall(target_position)
