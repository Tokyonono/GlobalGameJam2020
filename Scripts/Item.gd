extends Sprite

enum ShieldCondition {CORRECT=0, RUST=1, CRACK=2}
var condition = ShieldCondition.CORRECT
var target_position = null
var lerp_progress = 0.0
var lerp_speed = 2.5
var start_position = null
var start_scale = null
var start_transform = null
var target_scale = null
var flash_duration = 0.15
var flash_timer = 0.0
var failstate = false

# Called when the node enters the scene tree for the first time.
func _ready():
	update_texture()

func update_texture():
	match condition:
		ShieldCondition.CORRECT:
			texture = load("res://Art/Shield_Correct.png")
		ShieldCondition.RUST:
			texture = load("res://Art/Shield_Rust.png") 
		ShieldCondition.CRACK:
			texture = load("res://Art/Shield_Cracked.png")

func clean_rust():
	condition = ShieldCondition.CORRECT
	_flash(flash_duration)
	
func fix_crack():
	condition = ShieldCondition.CORRECT
	_flash(flash_duration)

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

func _on_fail():
	target_position = null
	failstate = true
	lerp_progress = 0.0
	set_global_scale(Vector2(1.5,1.5))
	modulate = Color.black	
	z_index = -1
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_tick_position(delta)
	_tick_color(delta)
	_tick_failure(delta)

func _tick_position(delta):
	if failstate: return
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
	if flash_timer <= 0.0:
		update_texture()

var accel = 1.0
func _tick_failure(delta):
	if !failstate: return
	var speed = 15
	accel += delta * speed
	set_position(position + Vector2(-1,-1) * speed + Vector2(0,1.8) * accel);
	set_rotation(get_rotation() - delta)
	lerp_progress += delta
