class_name Enemy_State extends Node

var enemy:Enemy
var enemy_state_machine: Enemy_State_Machine

func _ready():
	pass


func Enter()->void:
	pass

func Init()->void:
	pass

func Exit()->void:
	pass

func Process(_delta:float)->Enemy_State:
	return	null


func Physics(delta:float)->Enemy_State:
	return null

#func HandleInput(_event:InputEvent)->State:
	#return null
