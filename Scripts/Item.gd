extends Sprite

var faulty = false
var target_position = null
var lerp_progress = 0.0
var lerp_speed = 1.4
var start_position = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randi_range(0, 100)
	if my_random_number < 20:
		faulty = true
		modulate = Color(1,0,0)

func _set_target_position(var target):
	start_position = get_global_position()
	target_position = target
	lerp_progress = 0.0
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if target_position != null:
		#transform = transform.interpolate_with(target_transform, lerp_progress);
		var new_pos = start_position.linear_interpolate(target_position, lerp_progress)
		set_global_position(new_pos)
		lerp_progress += lerp_speed * delta
		if lerp_progress >= 1.0:
			lerp_progress = 1.0
			target_position = null
