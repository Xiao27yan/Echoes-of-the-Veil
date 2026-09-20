class_name World extends Node



func _ready() -> void:
	var cursor_texture = load("res://GeneralNodes/Cursor/crosshair176.png")

	Input.set_custom_mouse_cursor(
		cursor_texture,
		Input.CURSOR_ARROW,
		Vector2(20,20)
	)


func _process(delta: float) -> void:
	pass
