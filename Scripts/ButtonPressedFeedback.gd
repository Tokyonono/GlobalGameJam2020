extends Sprite

var original_modulate = null
var lerp_progress = 0.0
var lerp_speed = 4
var fading_out = false

# Called when the node enters the scene tree for the first time.
func _ready():
	original_modulate = modulate
	pass # Replace with function body.

func start_fading():
	fading_out = true
	lerp_progress = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !fading_out:
		return
	modulate = Color.white.linear_interpolate(original_modulate, lerp_progress)
	lerp_progress += lerp_speed * delta
	if lerp_progress >= 1.0:
		lerp_progress = 1.0
		fading_out = false
