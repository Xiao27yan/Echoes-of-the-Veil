class_name Player extends CharacterBody2D
#冰霜领域
@export var ice_field_scene: PackedScene

var ice_field_preview: Node2D
var ice_field_aiming: bool = false
#魔法波
var magic_wave_preview: MagicWave
var magic_wave_aiming: bool = false

#流星雨
var meteor_rain_preview: MeteorRain
var meteor_aiming: bool = false

var mouse_direction:Vector2 = Vector2.ZERO
var max_hp:int =20
var direction:Vector2 = Vector2.ZERO
var cardinal_direction:Vector2 = Vector2.RIGHT
var hp:int =20
var invulnerable:bool =false

signal player_damaged
signal player_destroyed
#魔法波实例
@export var magic_wave_scene: PackedScene
#流星雨实例
@export var meteor_rain_scene: PackedScene

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

@onready var projectile_component: PlayerProjectileComponent = $ProjectileComponent


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
		
		
func update_hp(delta:int)->void:
	hp = clampi(hp +delta,0,max_hp)
	PlayerHud.update_hp(hp,max_hp)
	pass
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("meteor_rain"):
		StartMeteorRain()
		
	if event.is_action_pressed("magic_wave"):
		StartMagicWave()	
		
	if event.is_action_pressed("ice_field"):
		StartIceField()	

	if meteor_aiming and event.is_action_pressed("ui_accept"):
		ConfirmMeteorRain()

	if magic_wave_aiming and event.is_action_pressed("ui_accept"):
		ConfirmMagicWave()
		

	if ice_field_aiming and event.is_action_pressed("ui_accept"):
		ConfirmIceField()
	
	return
	

	
#	陨石法阵---------------------------------------
func StartMeteorRain() -> void:
	# 已经在瞄准 → 取消施法
	if meteor_aiming:
		meteor_aiming = false

		if meteor_rain_preview:
			meteor_rain_preview.queue_free()
			meteor_rain_preview = null

		return

	# 开始瞄准
	meteor_aiming = true

	meteor_rain_preview = meteor_rain_scene.instantiate()
	get_tree().current_scene.add_child(meteor_rain_preview)

	meteor_rain_preview.player = self
	
func ConfirmMeteorRain() -> void:
	if not meteor_aiming:
		return

	meteor_aiming = false

	meteor_rain_preview.Confirm()

#魔法波----------------------------------------------

func StartMagicWave() -> void:
	if magic_wave_aiming:
		magic_wave_aiming = false

		if magic_wave_preview:
			magic_wave_preview.queue_free()
			magic_wave_preview = null

		return

	magic_wave_aiming = true

	magic_wave_preview = magic_wave_scene.instantiate()

	get_tree().current_scene.add_child(magic_wave_preview)

	magic_wave_preview.player = self


func ConfirmMagicWave() -> void:
	if not magic_wave_aiming:
		return

	magic_wave_aiming = false

	magic_wave_preview.Confirm()


#冰霜领域----------------------------------------------
func StartIceField() -> void:
	# 已经在瞄准 → 取消施法
	if ice_field_aiming:
		ice_field_aiming = false
		if ice_field_preview:

			ice_field_preview.queue_free()
			ice_field_preview = null
		return
	# 开始瞄准
	ice_field_aiming = true
	ice_field_preview = ice_field_scene.instantiate()
	get_tree().current_scene.add_child(
		ice_field_preview
	)

	ice_field_preview.player = self

func ConfirmIceField() -> void:
	if not ice_field_aiming:

		return
	ice_field_aiming = false
	ice_field_preview.Confirm()
