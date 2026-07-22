class_name State_Stun extends State

var _direction:Vector2 
var damaged_position:Vector2 
var _animation_finished:bool  = false

@onready var next_state: State_Idle = $"../Idle"


func Init()->void:
	player.player_damaged.connect(OnEnemyDamaged)

func _ready():
	pass
	
func Process(_delta:float)->State:
	player.velocity -=player.velocity*player.decelerate_speed*_delta
	if  _animation_finished == true:
		return next_state
	return null

func Enter()->void:
	_animation_finished = false
	_direction = -player.global_position.direction_to(damaged_position)
	player.direction = _direction
	player.SetDirection()
	player.velocity = _direction*player.knockback_speed
	player.UpdateAnimation('stun')
	player.make_invulnerable()
	player.sprite.animation_finished.connect(_on_animation_finished)
	




func OnEnemyDamaged(hurt_box:HurtBox)->void:
	damaged_position = hurt_box.global_position
	state_machine.ChangeState(self)


func _on_animation_finished():
	player.sprite.animation_finished.disconnect(_on_animation_finished)
	_animation_finished = true
	
