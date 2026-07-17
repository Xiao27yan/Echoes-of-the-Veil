class_name State_Attack	extends State

var attacking:bool = false

@onready var idle: State_Idle = $"../Idle"
@onready var walk: State_Walk = $"../Walk"

@export_range(1,20,0.5) var decelerate_speed:float =5


func Enter()->void:
	attacking = true
	player.hurt_box.monitoring = true
	player.UpdateAnimation("attack_hit")
	if not player.sprite.animation_finished.is_connected(EndAttack):
		player.sprite.animation_finished.connect(EndAttack)
	
func Process(_delta:float)->State:
	player.velocity -= decelerate_speed*_delta*player.velocity
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	


func EndAttack()->void:
	attacking  =  false
	player.hurt_box.monitoring = false
