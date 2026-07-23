class_name OrcUnitSpawner
extends Node2D

@export var unit_scene:PackedScene
@export var spawn_count:bool=true
@export var spawn_interval:float = 1.0


func _ready():

	spawn_units()


func spawn_units() -> void:

	while(spawn_count):

		Spawn()

		await get_tree().create_timer(spawn_interval).timeout



func Spawn():

	if unit_scene == null:
		return

	var unit = unit_scene.instantiate()

	get_parent().add_child(unit)

	unit.global_position = global_position + Vector2(
		randf_range(-50,50),
		randf_range(-50,50)
	)
