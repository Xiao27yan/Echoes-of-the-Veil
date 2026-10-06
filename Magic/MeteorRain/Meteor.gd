class_name Meteor
extends Node2D


@export var fall_height: float = 300.0
@export var fall_time: float = 0.5


@onready var meteor_sprite: AnimatedSprite2D = $AnimatedSprite2D


var target_position: Vector2


func StartFall(position: Vector2) -> void:
	target_position = position

	# 从目标位置上方出现
	global_position = target_position + Vector2(0, -fall_height)

	# 播放陨石下落动画
	meteor_sprite.visible = true
	meteor_sprite.play("fall")


	# 陨石落下
	var tween := create_tween()

	tween.tween_property(
		self,
		"global_position",
		target_position,
		fall_time
	)

	tween.tween_callback(OnImpact)


func OnImpact() -> void:
	print("陨石落地：", global_position)

	# 播放爆炸动画
	meteor_sprite.play("burst")

	# 等待爆炸动画播放完成
	await meteor_sprite.animation_finished

	# 爆炸结束，删除陨石
	queue_free()
