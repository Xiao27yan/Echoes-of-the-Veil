@tool
extends CanvasLayer

@export_group("Rain")
#雨滴数量
@export_range(100, 10000, 50) var amount_value: int = 2200:
	set(value):
		amount_value = value
		_apply_settings()
#例子存在的时间
@export_range(0.5, 10.0, 0.1) var lifetime_value: float = 1.4:
	set(value):
		lifetime_value = value
		_apply_settings()
#覆盖范围
@export var coverage_margin: Vector2 = Vector2(160.0, 220.0):
	set(value):
		coverage_margin = value
		_apply_settings()
#雨滴生成的区域亮度
@export_range(1.0, 120.0, 1.0) var emission_band_height: float = 18.0:
	set(value):
		emission_band_height = value
		_apply_settings()
#		雨滴的方向
@export var fall_direction: Vector2 = Vector2(-0.08, 1.0):
	set(value):
		fall_direction = value
		_apply_settings()
#		雨滴下落的速度最小值
@export_range(50.0, 2000.0, 10.0) var speed_min: float = 900.0:
	set(value):
		speed_min = value
		_apply_settings()
		#		雨滴下落的速度最大值
@export_range(50.0, 2500.0, 10.0) var speed_max: float = 1250.0:
	set(value):
		speed_max = value
		_apply_settings()
#		雨滴的透度
@export_range(0.0, 1.0, 0.01) var opacity: float = 0.38:
	set(value):
		opacity = value
		_apply_settings()
#		雨滴的尺寸
@export_range(1, 8, 1) var drop_width: int = 2:
	set(value):
		drop_width = value
		_apply_settings()
@export_range(6, 64, 1) var drop_height: int = 26:
	set(value):
		drop_height = value
		_apply_settings()

@export_group("Viewport")
@export var auto_fit_viewport: bool = true
@export var canvas_layer_index: int = 1:
	set(value):
		canvas_layer_index = value
		layer = value
		_apply_settings()

var _last_viewport_size: Vector2 = Vector2.ZERO

func _ready() -> void:
	_apply_settings()
	_update_layout(true)

func _process(_delta: float) -> void:
	if auto_fit_viewport:
		_update_layout()

func _apply_settings() -> void:
	layer = canvas_layer_index
	var particles := _get_particles()
	if particles == null:
		return

	particles.amount = amount_value
	particles.lifetime = lifetime_value
	particles.preprocess = lifetime_value
	particles.fixed_fps = 60
	particles.interpolate = true
	particles.fract_delta = true
	particles.local_coords = false
	particles.one_shot = false
	particles.explosiveness = 0.0
	particles.randomness = 0.2
	particles.emitting = true
	particles.texture = _build_drop_texture()
	particles.process_material = _build_process_material(_get_viewport_size())

	_update_layout(true)

func _update_layout(force: bool = false) -> void:
	var viewport_size := _get_viewport_size()
	if not force and viewport_size == _last_viewport_size:
		return
	_last_viewport_size = viewport_size

	var particles := _get_particles()
	if particles == null:
		return

	particles.position = Vector2(viewport_size.x * 0.5, -coverage_margin.y)
	particles.visibility_rect = Rect2(
		Vector2(-viewport_size.x * 0.5 - coverage_margin.x, -coverage_margin.y - drop_height * 2.0),
		Vector2(
			viewport_size.x + coverage_margin.x * 2.0,
			viewport_size.y + coverage_margin.y * 2.0 + drop_height * 4.0
		)
	)
	particles.process_material = _build_process_material(viewport_size)

func _build_process_material(viewport_size: Vector2) -> ParticleProcessMaterial:
	var direction := _get_safe_direction()
	var material := ParticleProcessMaterial.new()
	material.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	material.emission_box_extents = Vector3(viewport_size.x * 0.5 + coverage_margin.x, emission_band_height, 0.0)
	material.direction = Vector3(direction.x, direction.y, 0.0)
	material.spread = 2.0
	material.gravity = Vector3.ZERO
	material.initial_velocity_min = min(speed_min, speed_max)
	material.initial_velocity_max = max(speed_min, speed_max)
	material.scale_min = 1.0
	material.scale_max = 1.0
	material.color = Color(1.0, 1.0, 1.0, 1.0)
	return material

func _build_drop_texture() -> Texture2D:
	var safe_height: int = max(drop_height, 6)
	var safe_width: int = max(drop_width, 1)
	var direction := _get_safe_direction()
	var horizontal_shift: int = int(ceil(abs(direction.x / max(abs(direction.y), 0.001)) * float(safe_height - 1)))
	var texture_width: int = safe_width + horizontal_shift * 2
	var image := Image.create(texture_width, safe_height, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.0, 0.0, 0.0, 0.0))

	var x_offset: float = direction.x / max(abs(direction.y), 0.001) * float(safe_height - 1)
	var center_x: float = float(texture_width - 1) * 0.5 - x_offset * 0.5

	for y in range(safe_height):
		var t: float = float(y) / float(max(safe_height - 1, 1))
		var alpha: float = _drop_alpha(t) * opacity
		var line_x: float = center_x + x_offset * t
		for x in range(texture_width):
			var distance: float = abs((float(x) + 0.5) - line_x)
			var half_width: float = max(float(safe_width) * 0.5, 0.5)
			if distance > half_width:
				continue
			var edge: float = 1.0 - distance / half_width
			image.set_pixel(x, y, Color(0.82, 0.9, 1.0, alpha * edge))

	return ImageTexture.create_from_image(image)

func _drop_alpha(t: float) -> float:
	if t < 0.15:
		return lerpf(0.0, 0.35, t / 0.15)
	if t < 0.75:
		return lerpf(0.35, 1.0, (t - 0.15) / 0.6)
	return lerpf(1.0, 0.0, (t - 0.75) / 0.25)

func _get_particles() -> GPUParticles2D:
	return get_node_or_null("Particles") as GPUParticles2D

func _get_viewport_size() -> Vector2:
	var viewport := get_viewport()
	if viewport == null:
		return Vector2(1280.0, 720.0)
	var viewport_size := viewport.get_visible_rect().size
	if viewport_size == Vector2.ZERO:
		return Vector2(1280.0, 720.0)
	return viewport_size

func _get_safe_direction() -> Vector2:
	if fall_direction.length_squared() <= 0.0001:
		return Vector2.DOWN
	return fall_direction.normalized()
