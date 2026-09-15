class_name State_Attack	extends State 
 
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $"../../AudioStreamPlayer2D"

var frame:int 
var attacking:bool = false 
 
@onready var idle: State_Idle = $"../Idle" 
@onready var walk: State_Walk = $"../Walk" 
 
@export_range(1,20,0.5) var decelerate_speed:float =5 
@export var shoot_sound: AudioStream
 
func Enter()->void: 
	attacking = true 
	player.UpdateAnimation('attack_hit') 
	player.attack_component.Attack()
	
	
# 	hit动画播放完就启动EndAttack方法
	if not player.sprite.animation_finished.is_connected(EndAttack): 
		player.sprite.animation_finished.connect(EndAttack) 
	
		 
func Process(_delta:float)->State: 
	OnFrameChanged() 
	if frame>3 and frame <5 : 
		player.hurt_box.monitoring = true 
	player.velocity = player.direction * player.move_speed
#	人物朝向跟着鼠标
	player.SetMouseDirection()
	
	 #
	#if attacking == false: 
		#if player.direction == Vector2.ZERO: 
			#return idle 
		#else: 
			#return walk 
	return null 
	 
 
 
func EndAttack()->void: 
	
	if Input.is_action_pressed("attack"):
		player.attack_component.Attack()
		player.UpdateAnimation("attack_hit")
	
		return
	print("攻击结束") 
	attacking  =  false 
	
	if player.direction == Vector2.ZERO:
		player.state_machine.ChangeState(idle)
	else:
		player.state_machine.ChangeState(walk)
		
	player.hurt_box.monitoring = false 
 
func OnFrameChanged() -> void: 
	frame = player.sprite.frame 
