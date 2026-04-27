extends CanvasLayer
@onready var player2 = $PlayerTwo
@onready var player1 = $PlayerOne

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player2.flip_h = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
