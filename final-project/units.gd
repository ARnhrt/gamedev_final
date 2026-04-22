extends Node2D

@export var grid_position: Vector2i = Vector2i.ZERO
@export var move_range = 3
@export var team: String = "red"

@onready var world = get_parent().get_parent()
@onready var ground = world.get_node("Ground")
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	snap_to_grid()
	anim.play("idle")

	if team == "red":
		anim.flip_h = false
	else:
		anim.flip_h = true

func snap_to_grid() -> void:
	global_position = ground.to_global(ground.map_to_local(grid_position))
	
func set_selected(selected: bool) -> void:
	if selected:
		scale = Vector2(1.1, 1.1)
	else:
		scale = Vector2(1.0, 1.0)
