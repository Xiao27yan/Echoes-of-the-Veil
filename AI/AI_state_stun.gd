class_name AI_State_Stun extends AI_State

var _direction:Vector2 
var damaged_position:Vector2 
var _animation_finished:bool  = false

@onready var chase: AI_State_Chase = $"../Chase"
@onready var next_state: AI_State_Idle = $"../Idle"
@onready var idle: AI_State_Idle = $"../Idle"


func Init()->void:
	actor.enemy_damaged.connect(OnEnemyDamaged)

func Enter()->void:
	_animation_finished = false
	_direction = damaged_position.direction_to(actor.global_position)
	actor.direction = _direction
	actor.velocity = actor.direction*actor.knockback_speed

	actor.UpdateAnimation('stun')	
	actor.make_invulnerable()
	if not actor.sprite.animation_finished.is_connected(_on_animation_finished):
		actor.sprite.animation_finished.connect(_on_animation_finished)
	pass
	
func Process(_delta:float)->AI_State:
	
	if _animation_finished == true:
		if is_instance_valid(actor.target):
				return chase
	
		return next_state
		
	actor.velocity -= actor.velocity*actor.decelerate_speed*_delta
	
	return
	

func OnEnemyDamaged(hurt_box:HurtBox):
	damaged_position = hurt_box.global_position
	state_machine.ChangeState(self)
	
func  _on_animation_finished():
	_animation_finished = true
	actor.sprite.animation_finished.disconnect(_on_animation_finished)
