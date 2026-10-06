class_name PlayerProjectileComponent
extends AttackComponent

@export var effect: PackedScene

@onready var cast_point: Marker2D = $"../cast_point"


func Attack():

	var projectile = effect.instantiate()

	get_tree().current_scene.add_child(projectile)

	projectile.global_position = cast_point.global_position

	var mouse_position = actor.get_global_mouse_position()

	var direction = cast_point.global_position.direction_to(mouse_position)

	# 在原方向基础上随机偏移 ±5°
	var angle_offset = deg_to_rad(randf_range(-5.0, 5.0))

	direction = direction.rotated(angle_offset)

	projectile.direction = direction
