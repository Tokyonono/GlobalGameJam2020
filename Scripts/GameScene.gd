extends Node2D

var preloaded_item = preload("res://Scenes/Item.tscn")
var all_items = []
var window_size = OS.window_size
var item_initial_offset = Vector2(-150, 150)
var speed = 150
var generate_every_x_seconds = 1.5
var accumulator = 0
var trash_position = 150

# Called when the node enters the scene tree for the first time.
func _ready():
	_gen_new_item()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if accumulator > generate_every_x_seconds:
		accumulator = 0
		_gen_new_item()
	else:
		accumulator += delta
	for item in all_items:
		item.position.x -= delta * speed
	if all_items.size() != 0 && all_items.front().position.x <= trash_position:
		_fall_into_trash(all_items.front())

func _input(event):
    if event.is_action_pressed("approve_item") && all_items.size() != 0:
        _fall_into_trash(all_items.front())
		
func _gen_new_item():
	var new_item = preloaded_item.instance()
	all_items.push_back(new_item)
	_set_initial_position(new_item)
	add_child(new_item)

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
