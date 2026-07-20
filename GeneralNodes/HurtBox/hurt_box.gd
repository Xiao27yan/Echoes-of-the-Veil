class_name HurtBox extends Area2D

@export var damage:int =1
@onready var player
@onready var hurt_box_shape: CollisionShape2D = $CollisionShape2D

func _ready():
	player = get_parent()
	area_entered.connect(HitBoxEntered)

func HitBoxEntered(a:Area2D)->void:
	if a is HitBox:
		a.TakeDamaged(self)
		
	
func UpdateHurtBoxDirection() -> void:
	if player.cardinal_direction == Vector2.DOWN:
		hurt_box_shape.position = Vector2(0,0)
	elif player.cardinal_direction == Vector2.UP:
		hurt_box_shape.position = Vector2(0, -18)
	elif player.cardinal_direction == Vector2.LEFT:
		hurt_box_shape.position = Vector2(-16, -6)
	elif player.cardinal_direction == Vector2.RIGHT:
		hurt_box_shape.position = Vector2(16, -6)
