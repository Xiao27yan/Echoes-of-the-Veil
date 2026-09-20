class_name ScoreManager
extends Node

signal score_changed(new_score: int)

var score: int = 0


func add_score(value: int) -> void:
	score += value
	score_changed.emit(score)


func reset_score() -> void:
	score = 0
	score_changed.emit(score)


func get_score() -> int:
	return score
