class_name HurtBox extends Area2D

@export var damage:int = 1

func _ready():
#	自动把进入区域的传参了
	area_entered.connect(HitBoxEntered)

func HitBoxEntered(a:Area2D)->void:
	if a is HitBox:
		a.TakeDamaged(self)
