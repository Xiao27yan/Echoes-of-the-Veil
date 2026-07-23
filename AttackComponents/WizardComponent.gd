class_name WizardComponent
extends AttackComponent

@export var projectile_scene: PackedScene

@onready var cast_point: Marker2D = $"../CastPoint"

func Attack():

	if actor.target == null:
		return

	var projectile = projectile_scene.instantiate()

	get_tree().current_scene.add_child(projectile)

	projectile.global_position = cast_point.global_position

	projectile.direction = cast_point.global_position.direction_to(
		actor.target.global_position
	)
