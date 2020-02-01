extends Node2D

var preloaded_item = preload("res://Scenes/Item.tscn")
var all_items = []
var window_size = OS.window_size
var item_initial_offset = Vector2(-150, 150)
var speed = 150
var generate_every_x_seconds = 1.5
var accumulator = 0
var trash_position = 150
var interval = 50

onready var conveyor = get_node("Conveyor")

# Called when the node enters the scene tree for the first time.
func _ready():
	_push_into_conveyor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if accumulator > generate_every_x_seconds:
		accumulator = 0
		_gen_new_item()
	else:
		accumulator += delta
	if all_items.size() != 0 && all_items.front().position.x <= trash_position:
		_fall_into_trash(all_items.front())

func _input(event):
	if all_items.size() != 0:
		if event.is_action_pressed("approve_item"):
			if all_items.front().faulty:
				$Label.text = "Miss"
			else:
				$Label.text = "Good"
			_next()
		elif event.is_action_pressed("reject_item"):
			if all_items.front().faulty:
				$Label.text = "Good"
			else:
				$Label.text = "Miss"
			_next()

func _push_into_conveyor():
	# for i in range(4):
	var new_item = preloaded_item.instance()
	_set_initial_position(new_item)
	add_child(new_item)
	conveyor._add(new_item)
		
func _gen_new_item():
	var new_item = preloaded_item.instance()
	all_items.push_back(new_item)
	_set_initial_position(new_item)
	add_child(new_item)

func _next():
	_push_into_conveyor()

func _set_initial_position(item):
	var position = window_size
	var sprite_size = item.get_rect().size
	position.x -= sprite_size.x/2 + item_initial_offset.x
	position.y -= sprite_size.y/2 + item_initial_offset.y
	item.set_position(position)
	
func _fall_into_trash(item):
	all_items.pop_front()
	remove_child(item)
	item.queue_free()
