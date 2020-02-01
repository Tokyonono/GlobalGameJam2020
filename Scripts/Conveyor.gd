extends Node2D

var slots = []
var incoming = []
var active = []

var max_processed = 3
var max_active = 7

# Called when the node enters the scene tree for the first time.
func _ready():
	# initialize across width all slots on the screen
	for i in range(7) :
		slots.append(get_node("slot_" + str(i)))

func _add(var item):
	if active.size() >= max_active:
		active.pop_front().free()
	if active.size() < max_active:
		active.push_back(item)
	else:
		incoming.push_back(item)
	_refresh_position_2()
	
func _current():
	if active.size() < 4: 
		return null
	elif active.size() < max_active:
		return active.front()
	return active[3]

func _refresh_position_2():
	var lead_index = slots.size() - active.size()
	for item in active:
		item._absorb_transform(slots[lead_index])
		lead_index += 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if active.size() < max_active and incoming.size() > 0:
		active.push_back(incoming.pop_front())
