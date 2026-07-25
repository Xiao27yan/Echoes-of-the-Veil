class_name Fireball
extends CharacterBody2D


@onready var hurt_box: HurtBox = $HurtBox
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


var direction: Vector2

@export var speed := 500
@export var life_time := 5.0


var is_bursting := false



func _ready():

	hurt_box.area_entered.connect(_on_hurt_box_area_entered)
	hurt_box.body_entered.connect(_on_hurt_box_body_entered)


	# 5秒自动消失
	await get_tree().create_timer(life_time).timeout

	if not is_bursting:
		_burst()



func _physics_process(delta):

	if is_bursting:
		return

	velocity = direction * speed

	move_and_slide()



func _on_hurt_box_area_entered(area):

	if is_bursting:
		return

	_burst()



func _on_hurt_box_body_entered(body):

	if is_bursting:
		return

	_burst()



func _burst():

	is_bursting = true

	velocity = Vector2.ZERO

	animated_sprite.play("burst")

	await animated_sprite.animation_finished

	queue_free()
