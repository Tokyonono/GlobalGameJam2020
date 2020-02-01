extends Node

signal game_ended(score)

enum State {START, GAME, PAUSE, RESULT}
enum Point {
	WRONG = -5,
	RIGHT = 5,
}

var current_state = State.START
var game_duration = 60.0 * 1.0 # Number of seconds
var game_paused = false
var score = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = game_duration

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var minutes = int($Timer.time_left)/60
	var seconds = int($Timer.time_left)%60
	var ms = int(($Timer.time_left - minutes*60 - seconds) * 100.0)
	$TimeLabel.text = "%dmin %ds %dms" % [minutes, seconds, ms]

func _input(event):
	if event.is_action_pressed("pause_game"):
		game_paused = !game_paused
		$Timer.paused = game_paused
		if (game_paused):
			current_state = State.PAUSE
		else:
			current_state = State.GAME

func load_game():
	current_state = State.START

func start_game():
	current_state = State.GAME
	score = 0
	$Timer.wait_time = game_duration
	$Timer.start()
	
func _end_game():
	current_state = State.RESULT
	emit_signal("game_ended", score)
	
func add_point(point):
	score += point
	$ScoreLabel.text = "Score: %d" % score

func _on_Timer_timeout():
	$Timer.stop()
	_end_game()
