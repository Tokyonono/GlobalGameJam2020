extends Sprite

var faulty = false
var target_position = null
var lerp_progress = 0.0
var lerp_speed = 2.5
var start_position = null
var start_scale = null
var start_transform = null
var target_scale = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randi_range(0, 100)
	if my_random_number < 20:
		faulty = true
		modulate = Color(1,0,0)

func _set_target_position(var targetPos, var targetScale):
	start_position = get_global_position()
	target_position = targetPos
	target_scale = targetScale
	lerp_progress = 0.0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target_position != null:
		#transform = transform.interpolate_with(target_transform, lerp_progress);
		var new_pos = position.linear_interpolate(target_position, lerp_progress)
		var new_scale = scale.linear_interpolate(target_scale, lerp_progress)
		set_global_position(new_pos)
		set_global_scale(new_scale)
		lerp_progress += lerp_speed * delta
		if lerp_progress >= 1.0:
			lerp_progress = 1.0
			target_position = null	
