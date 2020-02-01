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
	#_load_texture('Blue', 'Missing')
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var my_random_number = rng.randi_range(0, 100)
	if my_random_number < 20:
		faulty = true
		modulate = Color(1,0,0)
		
		


func _load_texture(itemColour, itemCondition):
	var text_path = ""
	if itemColour == 'Blue':
		if itemCondition == 'Missing':
			text_path = 'res://Art/Blue_Missing.png'
		if itemCondition == 'Correct':
			text_path = 'res://Art/Blue_Correct.png'
			
	texture = load(text_path)
	
	#var rand_text_suffix = int( rand_range(1,3) ) #random int, 1-10
	
	#if rand_text_suffix == 1:
	#	text_path = 'res://Art/Blue_Missing.png'
	#if rand_text_suffix == 2:
	#	text_path = 'res://Art/Blue_Correct.png'
	##texture = load(text_path)


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
