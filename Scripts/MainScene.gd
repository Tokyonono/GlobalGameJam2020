extends Node

enum Screen {MENU, GAME, RESULT}
var start_screen = preload("res://Scenes/StartScene.tscn")
var game_screen = preload("res://Scenes/GameScene.tscn")
var end_screen = preload("res://Scenes/EndScene.tscn")
var navi = preload("res://Scenes/Navi.tscn")
var current_screen = null
var flash_duration = 0.3
var flash_timer = 0.0

onready var main_bg = get_node("main_bg")

# Called when the node enters the scene tree for the first time.
func _ready():
	_show_screen(Screen.MENU)

func _show_screen(screen):
	if current_screen != null:
		remove_child(current_screen)
	match screen:
		Screen.MENU:
			current_screen= start_screen.instance();
			current_screen.connect("start_game", self, "_game_started")
		Screen.GAME:
			current_screen= game_screen.instance();
			var current_navi= navi.instance()
			add_child(current_navi)
			current_screen.connect("navi", self, "_game_started")
			current_screen.connect("end_game", self, "_game_ended")
		Screen.RESULT:
			current_screen = end_screen.instance();
			current_screen.connect("start_game", self, "_game_started")
	add_child(current_screen);

func _game_started():
	_show_screen(Screen.GAME)
	
func _game_ended(score):
	_show_screen(Screen.RESULT)
	current_screen.set_score(score)

func _flash_error():
	flash_timer = flash_duration

func _tick_bg_color(delta):
	if flash_timer <= 0.0:
		return
	main_bg.modulate = Color.white.linear_interpolate(Color.red*2.5, flash_timer)
	flash_timer -= delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_tick_bg_color(delta)
