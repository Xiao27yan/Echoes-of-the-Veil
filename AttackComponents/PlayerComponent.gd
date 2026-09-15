class_name PlayerComponent
extends AttackComponent

@export var effect: PackedScene

@onready var cast_point: Marker2D = $"../cast_point"


func Attack():

	var projectile = effect.instantiate()

	get_tree().current_scene.add_child(projectile)

	projectile.global_position = cast_point.global_position

	var mouse_position = actor.get_global_mouse_position()

	projectile.direction = cast_point.global_position.direction_to(
		mouse_position
	)
