class_name Actor extends CharacterBody2D

@onready var detection_box: Area2D = $DetectionBox
var target:CharacterBody2D = null
var direction:Vector2 = Vector2.ZERO
var cardinal_direction:Vector2 = Vector2.DOWN
var DIR4 = [Vector2.DOWN,Vector2.UP,Vector2.LEFT,Vector2.RIGHT]
var hp:int = 6

enum Faction {
	PLAYER,
	ALLY,
	ENEMY,
	NEUTRAL
}

@export var faction: Faction = Faction.ENEMY

@export var knockback_speed:float = 400.0
@export var decelerate_speed :float =10.0
@export var move_speed:float = 50.0

@onready var hurt_box: HurtBox = $HurtBox
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var state_machine: AI_State_Machine = $StateMachine




@onready var hit_box: HitBox = $HitBox




signal enemy_destroyed(hurt_box:Area2D)
signal enemy_damaged(hurt_box:Area2D)

func _ready() -> void:
	hurt_box.monitoring  =  false
	hit_box.Damaged.connect(TakeDamaged)
	state_machine.Initialize(self)
	
	pass


func _process(delta: float) -> void:
	hurt_box.UpdateHurtBoxDirection()
	pass


func _physics_process(delta: float) -> void:
	# Move the CharacterBody2D using velocity.
	move_and_slide()
	

#func SetDirection()->bool:
	#var new_dir:Vector2 = cardinal_direction
	#if direction == Vector2.ZERO:
		#return false
	#if direction.y == 0:
		#if direction.x < 0:
				#new_dir = Vector2.LEFT
				#sprite.scale.x = -1
		#else:
			#sprite.scale.x = 1
			#new_dir =  Vector2.RIGHT
	#elif direction.x == 0:
		#new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	#if new_dir == cardinal_direction:
		#return false
		#
	#cardinal_direction = new_dir
	#
	#sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	#return true

func SetDirection()->bool:
	var new_dir:Vector2 = cardinal_direction
	
	if direction == Vector2.ZERO:
		return false
	
	if abs(direction.x) > abs(direction.y):
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	else:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
	
	if new_dir == cardinal_direction:
		return false
		
	cardinal_direction = new_dir
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true

func UpdateAnimation(state:String)->void:
	sprite.play(state + "_" + AnimDirection())


func AnimDirection()->String:
	return "side"


func TakeDamaged(hurt_box:HurtBox):
	hp -= hurt_box.damage
		
	if hp > 0:
		enemy_damaged.emit(hurt_box)
		print(name)
		print(hp)
	else:
		enemy_destroyed.emit(hurt_box)
	return
