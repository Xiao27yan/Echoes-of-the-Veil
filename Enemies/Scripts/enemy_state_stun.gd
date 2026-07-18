class_name Enemy_State_Stun extends Enemy_State

var _direction:Vector2 
var damaged_position:Vector2 
var _animation_finished:bool  = false

@export var knockback_speed:float = 400.0

@onready var next_state: Enemy_State_Idle = $"../Idle"

func Init()->void:
	enemy.enemy_damaged.connect(OnEnemyDamaged)

func Enter()->void:
	_animation_finished = false
	_direction = damaged_position.direction_to(enemy.global_position)
	enemy.direction = _direction
	enemy.velocity = enemy.direction*knockback_speed

	enemy.UpdateAnimation('stun')	
	enemy.sprite.animation_finished.connect(_on_animation_finished)
	pass
	
func Process(_delta:float)->Enemy_State:
	
	if _animation_finished == true:
		return next_state
		
	enemy.velocity -= enemy.velocity*enemy.decelerate_speed*_delta
	
	return
	

func OnEnemyDamaged(hurt_box:HurtBox):
	damaged_position = hurt_box.global_position
	enemy_state_machine.ChangeState(self)
	
func  _on_animation_finished():
	_animation_finished = true
	enemy.sprite.animation_finished.disconnect(_on_animation_finished)
