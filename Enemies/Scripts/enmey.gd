class_name Enemy extends CharacterBody2D

var direction:Vector2 = Vector2.ZERO
var cardinal_direction:Vector2 = Vector2.DOWN
var DIR4 = [Vector2.DOWN,Vector2.UP,Vector2.LEFT,Vector2.RIGHT]
var hp:int = 6

@export var decelerate_speed :float =10.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var enemy_state_machine: Enemy_State_Machine = $EnemyStateMachine
@onready var hit_box: HitBox = $HitBox

signal enemy_destroyed(hurt_box:Area2D)
signal enemy_damaged(hurt_box:Area2D)

func _ready() -> void:
	hit_box.Damaged.connect(TakeDamaged)
	enemy_state_machine.Initialize(self)
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	# Move the CharacterBody2D using velocity.
	move_and_slide()
	

func SetDirection()->bool:
	var new_dir:Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
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
