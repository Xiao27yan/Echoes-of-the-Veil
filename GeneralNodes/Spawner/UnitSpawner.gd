class_name UnitSpawner
extends Node2D



@export var spawn_list:Array[UnitSpawnData]


func _ready():

	await get_tree().process_frame

	StartSpawn()



func StartSpawn():

	for data in spawn_list:

		for i in data.amount:

			Spawn(data)

			await get_tree().create_timer(data.interval).timeout



func Spawn(data:UnitSpawnData):

	var unit = data.unit_scene.instantiate()


	get_parent().add_child(unit)

	unit.global_position = global_position
