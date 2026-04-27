extends CanvasLayer
@onready var player2 = $PlayerTwo
@onready var player1 = $PlayerOne
@onready var end_label = $EndLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player2.flip_h = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func show_end_screen(winning_team: String) -> void:
	end_label.visible = true
	end_label.text = winning_team.capitalize() + " Team Wins!"

	await get_tree().create_timer(2.0).timeout

	end_label.text = "Thanks for playing!"
