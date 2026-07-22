class_name State extends Node

static var player:Player
static var state_machine: PlayerStateMachine

func _ready():
	pass


func Enter()->void:

	pass
	

func Init()->void:
	pass

func Exit()->void:
	pass

func Process(_delta:float)->State:
	return	null


func Physics(delta:float)->State:
	return null

func HandleInput(_event:InputEvent)->State:
	return null
