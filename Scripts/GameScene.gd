extends Node2D

var preloaded_item = preload("res://Scenes/Item.tscn")
var window_size = OS.window_size
var item_initial_offset = Vector2(-150, 150)
var speed = 150
var generate_every_x_seconds = 1.5

onready var conveyor = get_node("Conveyor")

var flash_progress = 0.0
var screen_default = Color.black
var flash_fail = Color.red
var flash_good = Color.greenyellow
var flash_target = screen_default
var flash_speed = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_tick_flash(delta)

func _input(event):
	var current_item = conveyor._current();
	if current_item == null:
		_next()
		return

	if event.is_action_pressed("approve_item"):
		if current_item.faulty:
			$Label.text = "Miss"
			$GameState.add_point($GameState.Point.BROKE)
			_screen_flash(flash_fail, 0.8)
		else:
			$Label.text = "Good"
			$GameState.add_point($GameState.Point.PASSED)
		_next()
	elif event.is_action_pressed("reject_item"):
		if current_item.faulty:
			$Label.text = "Good"
			$GameState.add_point($GameState.Point.PASSED)
		else:
			$Label.text = "Miss"
			$GameState.add_point($GameState.Point.BROKE)
			_screen_flash(flash_fail, 0.8)
		_next()

func _push_into_conveyor():
	var new_item = preloaded_item.instance()
	_set_initial_position(new_item)
	add_child(new_item)
	conveyor._add(new_item)

func _next():
	_push_into_conveyor()

func _set_initial_position(item):
	var position = window_size
	var sprite_size = item.get_rect().size
	position.x -= sprite_size.x/2 + item_initial_offset.x
	position.y -= sprite_size.y/2 + item_initial_offset.y
	item.set_position(position)

func _screen_flash(color, duration):
	flash_progress = duration
	flash_target = color

func _tick_flash(delta):
	if flash_progress == 0.0:
		VisualServer.set_default_clear_color(screen_default)
		return

	var target_color = screen_default.linear_interpolate(flash_target, flash_progress)
	VisualServer.set_default_clear_color(target_color)
	flash_progress -= delta
	flash_progress = clamp(flash_progress, 0.0, 1.0)

func _on_UI_start_game():
	$GameState.start_game()
	_push_into_conveyor()
	_push_into_conveyor()
	_push_into_conveyor()
	_push_into_conveyor()


func _on_GameState_game_ended(score):
	$UI.show_game_over()
