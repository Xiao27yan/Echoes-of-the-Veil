class_name AI_State extends Node

var actor:Actor
var state_machine

func _ready():
	pass


func Enter()->void:
	pass

func Init()->void:
	pass

func Exit()->void:
	pass

func Process(_delta:float)->AI_State:
	return	null


func Physics(delta:float)->AI_State:
	return null

#func HandleInput(_event:InputEvent)->State:
	#return null
