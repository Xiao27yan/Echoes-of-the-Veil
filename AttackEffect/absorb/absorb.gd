class_name Absorb
extends AttackComponent

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var wizard: Actor = $".."
@onready var cast_point: Marker2D = $"../CastPoint"


func _ready() -> void:
	self.global_position = cast_point.global_position


func _process(_delta: float) -> void:
	if wizard.attack_timer > 0:
		if not animated_sprite.is_playing():
			play_absorb()
	else:
		if animated_sprite.is_playing():
			stop_absorb()


func play_absorb() -> void:
	animated_sprite.play("absorb")


func stop_absorb() -> void:
	animated_sprite.stop()
