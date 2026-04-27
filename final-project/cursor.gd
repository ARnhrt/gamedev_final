extends Node2D

@export var grid_position: Vector2i = Vector2i.ZERO

@onready var world = get_parent()
@onready var ground = world.get_node("Ground")

func _ready() -> void:
	snap_to_grid()

func _process(delta: float) -> void:
	handle_input()
	handle_selection()

	if Input.is_action_just_pressed("end_turn"):
		world.end_turn()

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
		if world.selected_unit == null:
			try_select_unit()
		else:
			try_move_or_attack()
			
func try_select_unit() -> void:
	var units_node = world.get_node("Units")

	for unit in units_node.get_children():
		if unit.grid_position == grid_position:
			world.select_unit(unit)
			return

	print("No unit on this tile")
	
func move_to_tile(grid_position) -> void:
	pass
	
func try_move_or_attack() -> void:
	var selected_unit = world.selected_unit
	var units_node = world.get_node("Units")

	# Check for attack FIRST
	for unit in units_node.get_children():
		if unit != selected_unit and unit.grid_position == grid_position:
			world.try_attack(selected_unit, unit)

			selected_unit.has_acted = true
			selected_unit.set_selected(false)
			world.selected_unit = null
			world.clear_move_tiles()
			return

	# Otherwise try movement
	if world.is_tile_in_range(selected_unit, grid_position):
		selected_unit.move_to_tile(grid_position)
		selected_unit.has_moved = true
		world.clear_move_tiles()
		print("Unit moved. Now you can attack or wait.")
	else:
		print("Invalid move")
			
