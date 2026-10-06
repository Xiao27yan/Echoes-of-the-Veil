
class_name State_Attack
extends State

@onready var idle: State_Idle = $"../Idle"
@onready var walk: State_Walk = $"../Walk"

var frame: int
var attacking: bool = false

@export var run_speed: float = 400.0
@export_range(1,20,0.5) var decelerate_speed: float = 5.0


func Enter() -> void:

	attacking = true
	player.UpdateAnimation("attack_hit")
	player.projectile_component.Attack()
	if not player.sprite.animation_finished.is_connected(EndAttack):
		player.sprite.animation_finished.connect(EndAttack)


func Process(_delta: float) -> State:

	OnFrameChanged()


	if Input.is_action_pressed("run"):
		player.velocity = player.direction * run_speed
	else:
		player.velocity = player.direction * player.move_speed


	player.SetMouseDirection()


	return null


func EndAttack() -> void:

	# 按住攻击键 → 继续攻击
	if Input.is_action_pressed("attack"):

		player.projectile_component.Attack()
		player.UpdateAnimation("attack_hit")

		return


	

	print("攻击结束")

	attacking = false

	# 确保攻击 HurtBox 关闭
	player.hurt_box.monitoring = false



	if player.direction == Vector2.ZERO:

		player.state_machine.ChangeState(idle)

	else:

		player.state_machine.ChangeState(walk)


func OnFrameChanged() -> void:

	frame = player.sprite.frame
