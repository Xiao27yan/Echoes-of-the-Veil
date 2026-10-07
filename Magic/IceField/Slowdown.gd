class_name SlowDown extends Area2D
@export var slow_rate := 0.5


func _on_area_2d_body_entered(body):

	if body is Actor:

		body.move_speed *= slow_rate



func _on_area_2d_body_exited(body):

	if body is Actor:

		body.move_speed /= slow_rate
