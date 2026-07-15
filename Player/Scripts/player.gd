class_name Player extends CharacterBody2D

var direction:Vector2 = Vector2.ZERO
var cardinal_direction:Vector2 = Vector2.DOWN
 

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: PlayerStateMachine = $stateMachine

func _ready() -> void:

	state_machine.Initialize(self)
	pass 

func _process(delta: float) -> void:
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
