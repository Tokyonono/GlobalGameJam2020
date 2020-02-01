extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
var timer

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
	
func show_game_over():
	show_message("Game Over")

	yield($MessageTimer, "timeout")

	$MessageLabel.text = "Are you ready?"
	$MessageLabel.show()

	yield(get_tree().create_timer(1), "timeout")

	$StartButton.show()

func _on_StartButton_pressed():
	timer = 60
	update_timer(timer)
	$StartButton.hide()
	$MessageLabel.hide()
	$GameTimer.start()
	emit_signal("start_game")
	

func _on_Timer_timeout():
	$MessageLabel.hide()
	
func update_timer(timer):
	$TimerLabel.text = str(timer)

func _on_GameTimer_timeout():
	if timer == 0:
		show_game_over()
	else:
		timer -= 1
		update_timer(timer)
