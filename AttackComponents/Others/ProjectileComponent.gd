class_name ProjectileComponent
extends AttackComponent

@export var effect: PackedScene

@onready var cast_point: Marker2D = $"../CastPoint"

func Attack():
	
	if actor.target == null:
		return
#实例化
	var effect = effect.instantiate()

	get_tree().current_scene.add_child(effect)

	effect.global_position = cast_point.global_position
	
	effect.direction = cast_point.global_position.direction_to(
		actor.target.global_position
	)
