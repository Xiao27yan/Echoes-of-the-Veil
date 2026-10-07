class_name IceCrystal
extends Node2D


@export var damage: float = 2

@export var active_time: float = 0.2

@export var cooldown_time: float = 1.0


@onready var hurt_box: HurtBox = $HurtBox
@onready var collision_shape: CollisionShape2D = $HurtBox/CollisionShape2D

func _ready():

	# 初始关闭伤害

	collision_shape.disabled = true
	StartAttackLoop()
func StartAttackLoop():

	while true:
		# 开启伤害

		collision_shape.disabled = false

		await get_tree().create_timer(
			active_time
		).timeout

		# 关闭伤害

		collision_shape.disabled = true
		await get_tree().create_timer(
			cooldown_time
		).timeout
