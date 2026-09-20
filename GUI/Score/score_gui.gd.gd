extends Control


@onready var score_label: Label = $ScoreLabel


func _ready() -> void:
	ScoreManagers.score_changed.connect(update_score)
	update_score(ScoreManagers.score)


func update_score(_score: int) -> void:
	score_label.text = "%06d" % _score
