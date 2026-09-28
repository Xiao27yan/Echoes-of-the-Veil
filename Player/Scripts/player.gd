class_name Player extends CharacterBody2D

var mouse_direction:Vector2 = Vector2.ZERO
var max_hp:int =20
var direction:Vector2 = Vector2.ZERO
var cardinal_direction:Vector2 = Vector2.RIGHT
var current_weapon = {
	"name":"slice",
	"attack_animation":"attack_slice",
	"damage":3
}
var hp:int =20
var invulnerable:bool =false

signal player_damaged
signal player_destroyed

@export var move_speed:float =200.0
@export var decelerate_speed :float =10.0
@export var knockback_speed:float = 400.0

enum Faction {
	PLAYER,
	ALLY,
	ENEMY,
	NEUTRAL
}
@export var faction: Faction = Faction.PLAYER

@onready var attack_component: PlayerComponent = $AttackComponent

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: PlayerStateMachine = $stateMachine
@onready var hit_box: HitBox = $HitBox
@onready var hurt_box: HurtBox = $HurtBox


func _ready() -> void:
	hurt_box.monitoring  =  false
	hit_box.Damaged.connect(TakeDamaged)
	state_machine.Initialize(self)
	update_hp(99)
	pass 

func _process(delta: float) -> void:
	hurt_box.UpdateHurtBoxDirection()
	direction = Vector2(
			Input.get_axis("left","right"),
			Input.get_axis("up","down")
		).normalized()
		
	mouse_direction = global_position.direction_to(
		get_global_mouse_position()
	)
	
	
	
		
	pass

func _physics_process(delta: float) -> void:
	
#这是Character2D根据velocity移动的方法
	move_and_slide()
	
func SetMouseDirection() -> void:
	if mouse_direction == Vector2.ZERO:
		return

	# 只有水平分量占主导时才切换朝向;
	# 垂直分量占主导(本该是 UP/DOWN)时没有对应美术,保持当前左右朝向不变
	if abs(mouse_direction.x) <= abs(mouse_direction.y):
		return

	var new_dir: Vector2 = Vector2.LEFT if mouse_direction.x < 0 else Vector2.RIGHT

	if new_dir == cardinal_direction:
		return

	cardinal_direction = new_dir

	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1	
	
	
#	四方向时候用
#func SetMouseDirection() -> void:
	#if mouse_direction == Vector2.ZERO:
		#return
#
	#var new_dir: Vector2
#
	#if abs(mouse_direction.x) > abs(mouse_direction.y):
		#new_dir = Vector2.LEFT if mouse_direction.x < 0 else Vector2.RIGHT
		#
		#
		#
	#else:
		#new_dir = Vector2.UP if mouse_direction.y < 0 else Vector2.DOWN
#
	#if new_dir == cardinal_direction:
		#return
#
	#cardinal_direction = new_dir
#
	#sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1	

func SetDirection()->bool:
	var new_dir:Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
#		四方向时候用
	#if direction.y==0:
		#new_dir = Vector2.LEFT if direction.x<0 else  Vector2.RIGHT
	#elif direction.x==0:
		#new_dir = Vector2.UP if direction.y<0 else Vector2.DOWN
		
	if direction.x != 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
		
	if new_dir ==  cardinal_direction:
		return false
	cardinal_direction = new_dir

	sprite.scale.x =-1 if cardinal_direction == Vector2.LEFT  else 1
	return true

func UpdateAnimation(state:String)->void:
	sprite.play(state+"_"+AnimDirection())


func AnimDirection()->String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
		
func make_invulnerable(invulnerable_duration:float=1.0)->void:
	invulnerable = true
	hit_box.monitoring = false	
	await get_tree().create_timer(invulnerable_duration).timeout
	invulnerable = false
	hit_box.monitoring = true
	pass
		
func TakeDamaged(hurt_box:HurtBox):
	if invulnerable:
		return
	
	
	update_hp(-hurt_box.damage)
		
	if hp > 0:
		player_damaged.emit(hurt_box)
		print(name)
		print(hp)
	else:
		player_destroyed.emit()
		update_hp(99)
	return
		
func _unhandled_input(_event: InputEvent) -> void:
	
	if _event.is_action_pressed("weapon1"):
		current_weapon.name  = 'slice'
		current_weapon.attack_animation="attack_slice"
		current_weapon.damage=3
		
	elif  _event.is_action_pressed("weapon2"):
		current_weapon.name  = 'pierce'
		current_weapon.attack_animation="attack_pierce"
		current_weapon.damage=2
	elif _event.is_action_pressed("weapon3"):
		current_weapon.name  = 'hit'
		current_weapon.attack_animation="attack_hit"
		current_weapon.damage=1
	hurt_box.damage  = current_weapon.damage
	
func update_hp(delta:int)->void:
	hp = clampi(hp +delta,0,max_hp)
	PlayerHud.update_hp(hp,max_hp)
	pass
	
