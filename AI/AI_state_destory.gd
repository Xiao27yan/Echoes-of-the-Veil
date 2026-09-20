class_name AI_State_Destory  extends AI_State

const DEATH_SMOKE = preload("res://AttackEffect/Smoke/smoke.tscn")

var _direction:Vector2 
var destoryed_position:Vector2 

@export var knockback_speed:float = 200.0
@onready var next_state: AI_State_Idle = $"../Idle"


func Init()->void:
	actor.enemy_destroyed.connect(OnEnemyDestory)


func Enter()->void:
	
	_direction = destoryed_position.direction_to(actor.global_position)
	actor.direction = _direction
	actor.SetDirection()
	actor.velocity = actor.direction *  knockback_speed
	actor.UpdateAnimation('death')
	print('死了 啊')
	
	

	actor.sprite.animation_finished.connect(AnimationFinished)
	
func Process(_delta:float)->AI_State:
	actor.velocity -= actor.velocity*actor.decelerate_speed*_delta
	return null
	

func OnEnemyDestory(hurt_box:HurtBox):
	destoryed_position = hurt_box.global_position
	actor.state_machine.ChangeState(self)

func AnimationFinished()->void:
	var death_smoke = DEATH_SMOKE.instantiate()
	death_smoke.global_position = actor.global_position
#	添加烟雾特效
	get_tree().current_scene.add_child(death_smoke)
#	添加分数
	ScoreManagers.add_score(actor.score_value)

	actor.queue_free()
func Exit()->void:
	actor.sprite.animation_finished.disconnect(AnimationFinished)
	queue_free()
	pass
