class_name HeartGUI extends Node

@onready var sprite: Sprite2D = $Sprite2D

#精灵图中 0 1 2 对应的是空心 半心 满心 因此思路是 血量改变时 根据 value 实时改变血量状态
var value:int = 2:
	set(_value):
		value =_value
		update_sprite()

func update_sprite()->void:
	sprite.frame = value
