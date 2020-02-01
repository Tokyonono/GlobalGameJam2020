extends Node

enum Screen {MENU, GAME, RESULT}
var main_menu_screen = preload("res://Scenes/UIScene.tscn")
var game_screen = preload("res://Scenes/GameScene.tscn")
var current_screen = null


# Called when the node enters the scene tree for the first time.
func _ready():
	_show_screen(Screen.MENU)

func _show_screen(screen):
	remove_child(current_screen)
	match screen:
		Screen.MENU:
			current_screen= main_menu_screen.instance();
			current_screen.connect("start_game", self, "_game_started")
		Screen.GAME:
			current_screen= game_screen.instance();
			current_screen.connect("end_game", self, "_game_ended")
		Screen.RESULT:
			current_screen = main_menu_screen.instance();
			current_screen.show_game_over()
	add_child(current_screen);

func _game_started():
	_show_screen(Screen.GAME)
	
func _game_ended():
	_show_screen(Screen.RESULT)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
