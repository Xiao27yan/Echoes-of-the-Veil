class_name LevelTileMap extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.ChangeTilemapBounds(GetTileMapBounds())
	pass # Replace with function body.

func GetTileMapBounds()->Array[Vector2]:
	var bounds :Array[Vector2]=[]
	bounds.append(
#		get_used_rect 地图左上角 这里是瓦片坐标 比如从第 0 列，第 0 行 到第 30 列，第 20 行  不是地图像素
		Vector2(get_used_rect().position* rendering_quadrant_size)
	)
	bounds.append(
#		get_used_rect 地图左上角 这里是瓦片个数 不是地图像素
		Vector2(get_used_rect().end* rendering_quadrant_size)
	)
	return bounds
