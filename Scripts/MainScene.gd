extends Node

enum Screen {MENU, GAME, RESULT}
var start_screen = preload("res://Scenes/StartScene.tscn")
var game_screen = preload("res://Scenes/GameScene.tscn")
var end_screen = preload("res://Scenes/EndScene.tscn")
var current_screen = null


# Called when the node enters the scene tree for the first time.
func _ready():
	_show_screen(Screen.MENU)

func _show_screen(screen):
	remove_child(current_screen)
	match screen:
		Screen.MENU:
			current_screen= start_screen.instance();
			current_screen.connect("start_game", self, "_game_started")
		Screen.GAME:
			current_screen= game_screen.instance();
			current_screen.connect("end_game", self, "_game_ended")
		Screen.RESULT:
			current_screen = end_screen.instance();
			current_screen.connect("start_game", self, "_game_started")
	add_child(current_screen);

func _game_started():
	_show_screen(Screen.GAME)
	
func _game_ended():
	#current_screen.set_score(score)
	_show_screen(Screen.RESULT)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
