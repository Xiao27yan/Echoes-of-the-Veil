class_name Iceball
extends CharacterBody2D


@onready var hurt_box: HurtBox = $HurtBox
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collision_shape_2d: CollisionShape2D = $HurtBox/CollisionShape2D


var direction: Vector2

@export var shoot_sound: AudioStream
@export var burst_sound: AudioStream

@export var speed := 800
@export var life_time := 5.0


var is_bursting := false



func _ready():
	hurt_box.area_entered.connect(body_entered)
	audio_stream_player_2d.stream = shoot_sound
	audio_stream_player_2d.play()

	# 5秒自动消失
	await get_tree().create_timer(life_time).timeout

	if not is_bursting:
		print("Iceball 5秒自动爆炸：", get_instance_id())
		_burst()



func _physics_process(delta):

	if is_bursting:
		return
	rotation = direction.angle()
	velocity = direction * speed

	move_and_slide()



func body_entered(area):
	print('--------------')
	if is_bursting ==true:
		return
	_burst()


func _burst():

	is_bursting = true
	collision_shape_2d.set_deferred("disabled", true)
	
	velocity = Vector2.ZERO
	
	audio_stream_player_2d.stream=burst_sound
	audio_stream_player_2d.play()
	
	animated_sprite.play("burst")
	await get_tree().create_timer(2).timeout
	print('冰球消失')
	queue_free()
	
