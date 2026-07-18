class_name Enemy_State_Destory  extends Enemy_State

var _direction:Vector2 
var destoryed_position:Vector2 

@export var knockback_speed:float = 200.0
@onready var next_state: Enemy_State_Idle = $"../Idle"

func Init()->void:
	enemy.enemy_destroyed.connect(OnEnemyDestory)


func Enter()->void:
	
	_direction = destoryed_position.direction_to(enemy.global_position)
	enemy.direction = _direction
	enemy.SetDirection()
	enemy.velocity = enemy.direction *  knockback_speed
	enemy.UpdateAnimation('death')
	enemy.sprite.animation_finished.connect(AnimationFinished)
	
func Process(_delta:float)->Enemy_State:
	enemy.velocity -= enemy.velocity*enemy.decelerate_speed*_delta
	return null
	

func OnEnemyDestory(hurt_box:HurtBox):
	destoryed_position = hurt_box.global_position
	enemy_state_machine.ChangeState(self)

func AnimationFinished()->void:
	enemy.queue_free()

func Exit()->void:
	enemy.sprite.animation_finished.disconnect(AnimationFinished)

	pass
