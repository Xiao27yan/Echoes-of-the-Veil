class_name HurtBox extends Area2D

@export var damage:int 
@onready var player: Player = $".."

func _ready():
#	自动把进入区域的传参了
	damage = player.current_weapon.damage
	player.weaponChanged.connect(weaponChanged)
	area_entered.connect(HitBoxEntered)

func HitBoxEntered(a:Area2D)->void:
	if a is HitBox:
		a.TakeDamaged(self)
		
func weaponChanged()->void:
	damage  = player.current_weapon.damage
	
