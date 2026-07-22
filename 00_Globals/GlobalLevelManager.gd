extends Node

var current_tilemap_bounds:Array[Vector2]

signal TileMapBoundChanged(bounds:Array[Vector2])

func _ready() -> void:
	pass 


func _process(delta: float) -> void:
	pass

func ChangeTilemapBounds(bounds:Array[Vector2])->void:
	current_tilemap_bounds =bounds
	TileMapBoundChanged.emit(bounds)
