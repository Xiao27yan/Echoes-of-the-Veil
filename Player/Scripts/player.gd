class_name Player extends CharacterBody2D

var direction:Vector2 = Vector2.ZERO
var cardinal_direction:Vector2 = Vector2.DOWN
var current_weapon = {
	"name":"slice",
	"attack_animation":"attack_slice",
	"damage":3
}
var hp:int =6

signal weaponChanged

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: PlayerStateMachine = $stateMachine
@onready var hit_box: HitBox = $HitBox
@onready var hurt_box_shape: CollisionShape2D = $HurtBox/CollisionShape2D
@onready var hurt_box: HurtBox = $HurtBox


func _ready() -> void:
	hurt_box.monitoring  =  false
	hit_box.Damaged.connect(TakeDamaged)
	state_machine.Initialize(self)
	pass 

func _process(delta: float) -> void:
	UpdateHurtBoxDirection()
	direction = Vector2(
			Input.get_axis("left","right"),
			Input.get_axis("up","down")
		).normalized()
	pass

func _physics_process(delta: float) -> void:
	
#这是Character2D根据velocity移动的方法
	move_and_slide()

func SetDirection()->bool:
	var new_dir:Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
	if direction.y==0:
		new_dir = Vector2.LEFT if direction.x<0 else  Vector2.RIGHT
	elif direction.x==0:
		new_dir = Vector2.UP if direction.y<0 else Vector2.DOWN
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
		
func TakeDamaged(hurt_box:HurtBox):
	hp-=hurt_box.damage
	print(name)
	print(hp)
	
func UpdateHurtBoxDirection() -> void:
	if cardinal_direction == Vector2.DOWN:
		hurt_box_shape.position = Vector2(0,0)
	elif cardinal_direction == Vector2.UP:
		hurt_box_shape.position = Vector2(0, -18)
	elif cardinal_direction == Vector2.LEFT:
		hurt_box_shape.position = Vector2(-16, -6)
	elif cardinal_direction == Vector2.RIGHT:
		hurt_box_shape.position = Vector2(16, -6)
		
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
	weaponChanged.emit()
