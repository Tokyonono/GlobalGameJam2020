extends Sprite

var faulty = false
var target_position = null
var lerp_progress = 0.0
var lerp_speed = 2.5
var start_position = null
var start_scale = null
var start_transform = null
var target_scale = null
var colour = 'Blue'
var condition = 'Correct'

var flash_timer = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	_load_texture(colour, condition)

func _set_Colour_Condition(itemColour, itemCondition):
	colour = itemColour
	condition = itemCondition
	if itemCondition != "Correct":
		faulty = true

func _load_texture(itemColour, itemCondition):
	var text_path = ""
	if itemColour == 'Blue':
		if itemCondition == 'Missing':
			text_path = 'res://Art/Blue_Missing.png'
		if itemCondition == 'Correct':
			text_path = 'res://Art/Blue_Correct.png'
			
	texture = load(text_path)


func _set_target_position(var targetPos, var targetScale):
	start_position = get_global_position()
	target_position = targetPos
	target_scale = targetScale
	lerp_progress = 0.0
	
func _absorb_transform(var sourceNode):
	_set_target_position(sourceNode.get_global_position(), sourceNode.get_global_scale())
	z_index = sourceNode.z_index

func _flash(var duration):
	flash_timer = duration
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_tick_position(delta)
	_tick_color(delta)

func _tick_position(delta):
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

func _tick_color(delta):
	if flash_timer <= 0.0:
		return
	modulate = Color.white.linear_interpolate(Color.white*10, flash_timer)
	flash_timer -= delta
