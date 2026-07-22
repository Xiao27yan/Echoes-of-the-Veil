class_name State_Attack	extends State

var frame:int
var attacking:bool = false

@onready var idle: State_Idle = $"../Idle"
@onready var walk: State_Walk = $"../Walk"

@export_range(1,20,0.5) var decelerate_speed:float =5



func Enter()->void:
	attacking = true
	player.UpdateAnimation('attack_'+player.current_weapon.name)
	if not player.sprite.animation_finished.is_connected(EndAttack):
		player.sprite.animation_finished.connect(EndAttack)
	
func Process(_delta:float)->State:
	OnFrameChanged()
	if frame>3 and frame <5 :
		player.hurt_box.monitoring = true
	player.velocity -= decelerate_speed*_delta*player.velocity
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	


func EndAttack()->void:
	print("攻击结束")
	attacking  =  false
	player.hurt_box.monitoring = false

func OnFrameChanged() -> void:
	frame = player.sprite.frame
