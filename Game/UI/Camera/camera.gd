extends Camera2D

@export_group("camera Shake")
@export var intensity = 1
@export var duration = 1
var start_time = 0 
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	randomize()
	set_process(false)

func _process(_delta: float) -> void:
	@warning_ignore("integer_division")
	var decreaser = (duration - (Time.get_ticks_msec() - start_time)) / duration
	
	var rand_x = rng.randf_range(-1, 1) * intensity * decreaser
	var rand_y = rng.randf_range(-1, 1) * intensity * decreaser
	
	offset = Vector2(rand_x, rand_y)
	
	if decreaser < 0:
		offset = Vector2.ZERO
		set_process(false)
		

func shake_camera(new_intensity = 1, new_duration = 1):
	intensity = float(new_intensity)
	duration = float(new_duration * 1000)
	start_time = Time.get_ticks_msec()
	
	set_process(true)
