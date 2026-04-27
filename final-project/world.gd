extends Node2D

@onready var move_tiles = $MoveTiles
@onready var ground = $Ground

var move_tile_scene = preload("res://movement_tile.tscn")
var selected_unit = null
var current_team: String = "red"


func select_unit(unit) -> void:
	if unit.team != current_team:
		print("Not this team's turn")
		return

	if unit.has_moved:
		print("This unit already moved")
		return

	if selected_unit != null:
		selected_unit.set_selected(false)

	selected_unit = unit
	selected_unit.set_selected(true)

	show_move_range(unit)
	print("Current selected unit: ", selected_unit.name)

func show_move_range(unit) -> void:
	clear_move_tiles()

	var move_range = unit.move_range
	var origin = unit.grid_position

	for x in range(-move_range, move_range + 1):
		for y in range(-move_range, move_range + 1):
			if abs(x) + abs(y) <= move_range:
				var tile_pos = origin + Vector2i(x, y)
				spawn_move_tile(tile_pos)

func spawn_move_tile(tile_pos: Vector2i) -> void:
	var tile = move_tile_scene.instantiate()
	move_tiles.add_child(tile)
	tile.global_position = ground.to_global(ground.map_to_local(tile_pos))

func clear_move_tiles() -> void:
	for child in move_tiles.get_children():
		child.queue_free()

func is_tile_in_range(unit, tile_pos: Vector2i) -> bool:
	var origin = unit.grid_position
	return abs(tile_pos.x - origin.x) + abs(tile_pos.y - origin.y) <= unit.move_range

func end_turn() -> void:
	clear_move_tiles()

	if selected_unit != null:
		selected_unit.set_selected(false)
		selected_unit = null

	for unit in $Units.get_children():
		if unit.team == current_team:
			unit.has_moved = false

	if current_team == "red":
		current_team = "grey"
	else:
		current_team = "red"

	print("Current turn: ", current_team)
	
func is_adjacent(pos1: Vector2i, pos2: Vector2i) -> bool:
	var dx = abs(pos1.x - pos2.x)
	var dy = abs(pos1.y - pos2.y)
	return dx + dy == 1
	
func try_attack(attacker, target) -> void:
	if attacker.team == target.team:
		return

	if is_adjacent(attacker.grid_position, target.grid_position):
		target.health -= 5
		print("Attacked ", target.name, " | HP:", target.health)

		if target.health <= 0:
			print(target.name, " defeated")
			check_win_condition()
			target.queue_free()

func check_win_condition():
	var red_exists = false
	var grey_exists = false

	for unit in $Units.get_children():
		if unit.team == "red":
			red_exists = true
		elif unit.team == "grey":
			grey_exists = true

	if not red_exists:
		print("Grey Wins!")
	elif not grey_exists:
		print("Red Wins!")
