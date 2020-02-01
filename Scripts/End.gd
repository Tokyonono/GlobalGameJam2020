extends CanvasLayer

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass	

func set_score(score):
	$ScoreLabel.text = str(score)

func _on_RestartButton_pressed():
	emit_signal("start_game")
