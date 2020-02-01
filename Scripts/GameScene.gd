extends Node2D

var preloaded_item = preload("res://Scenes/Item.tscn")
var window_size = OS.window_size
var item_initial_offset = Vector2(-150, 150)
var speed = 150
var generate_every_x_seconds = 1.5

onready var conveyor = get_node("Conveyor")

# Called when the node enters the scene tree for the first time.
func _ready():
	_push_into_conveyor()
	_push_into_conveyor()
	_push_into_conveyor()
	_push_into_conveyor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	var current_item = conveyor._current();
	if current_item == null:
		_next()
		return
	if event.is_action_pressed("approve_item"):
		if current_item.faulty:
			$Label.text = "Miss"
		else:
			$Label.text = "Good"
		_next()
	elif event.is_action_pressed("reject_item"):
		if current_item.faulty:
			$Label.text = "Good"
		else:
			$Label.text = "Miss"
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
