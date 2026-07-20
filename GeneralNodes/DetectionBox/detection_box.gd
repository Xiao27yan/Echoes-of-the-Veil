class_name Dectection_Box extends Area2D

@onready var orc: Enemy = $".."
@onready var chase: Enemy_State_Chase = $"../EnemyStateMachine/Chase"



func _ready() -> void:
	
	body_entered.connect(_on_detection_area_body_entered)
	body_exited.connect(_on_detection_area_body_exited)
	pass

func _process(delta: float) -> void:
	
	pass
	
func _on_detection_area_body_entered(body):
	if body is Player:
		orc.player = body
		orc.enemy_state_machine.ChangeState(chase)

func _on_detection_area_body_exited(body):

	if body is Player:
		orc.player = null
