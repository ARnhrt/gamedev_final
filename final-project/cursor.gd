extends Node2D

@export var grid_position: Vector2i = Vector2i.ZERO

@onready var world = get_parent()
@onready var ground = world.get_node("Ground")

func _ready() -> void:
	snap_to_grid()

func _process(_delta: float) -> void:
	handle_input()
	handle_selection()

func handle_input() -> void:
	var move := Vector2i.ZERO

	if Input.is_action_just_pressed("move_left"):
		move.x -= 1
	elif Input.is_action_just_pressed("move_right"):
		move.x += 1
	elif Input.is_action_just_pressed("move_up"):
		move.y -= 1
	elif Input.is_action_just_pressed("move_down"):
		move.y += 1

	if move != Vector2i.ZERO:
		try_move(move)

func try_move(direction: Vector2i) -> void:
	var new_pos = grid_position + direction
	var used_rect: Rect2i = ground.get_used_rect()

	if used_rect.has_point(new_pos):
		grid_position = new_pos
		snap_to_grid()
		print("Cursor tile: ", grid_position)

func snap_to_grid() -> void:
	global_position = ground.to_global(ground.map_to_local(grid_position))
	
func handle_selection() -> void:
	if Input.is_action_just_pressed("ui_accept"):
		var units_node = world.get_node("Units")
		
		for unit in units_node.get_children():
			if unit.grid_position == grid_position:
				world.select_unit(unit)
				return
				
		print("no unit on this tile")
			
