class_name HitBox extends Area2D

signal	Damaged(hurt_box:Area2D)

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass

func TakeDamaged(hurt_box:HurtBox):
	Damaged.emit(hurt_box)
	print('---------------')
	
	
