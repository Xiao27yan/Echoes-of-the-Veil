class_name AI_State_Attack extends AI_State
var attacking:bool = false
var frame:int

@onready var chase: AI_State_Chase = $"../Chase"
@onready var idle: AI_State_Idle = $"../Idle"
@onready var run: AI_State_Run = $"../Run"




func Enter()->void:
	attacking = true
	var anim = actor.attack_animations.pick_random()
	actor.UpdateAnimation(anim)
	actor.attack_component.Attack()
	if not actor.sprite.animation_finished.is_connected(EndAttack):
		actor.sprite.animation_finished.connect(EndAttack)
	
func Process(_delta:float)->AI_State:
	OnFrameChanged()
	if frame>3 and frame <5 :
		actor.hurt_box.monitoring = true
	actor.velocity -= actor.decelerate_speed*_delta*actor.velocity
	
	if attacking == false:
		if is_instance_valid(actor.target):
			return chase
		if actor.direction == Vector2.ZERO:
			return idle
		else:
			return run
	return null
	


func EndAttack()->void:
	attacking  =  false
	actor.hurt_box.monitoring = false
	
func OnFrameChanged() -> void:
	frame = actor.sprite.frame
