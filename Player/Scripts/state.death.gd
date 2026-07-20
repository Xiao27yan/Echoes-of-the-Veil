class_name State_Death extends State

var _animation_finished:bool=false

@onready var next_state: State_Idle = $"../Idle"

func Init()->void:
	player.player_destroyed.connect(OnEnemyDestoryed)
	pass


func Enter()->void:
	player.velocity = Vector2.ZERO
	_animation_finished=false
	player.UpdateAnimation('death')
	player.sprite.animation_finished.connect(_on_animation_finished)
	

func Process(_delta:float)->State:
	if _animation_finished == true:
		player.hp=6
		return next_state
	return null

func  OnEnemyDestoryed()->void:
	state_machine.ChangeState(self)

func _on_animation_finished():
	player.sprite.animation_finished.disconnect(_on_animation_finished)
	_animation_finished = true
