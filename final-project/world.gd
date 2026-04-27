extends Node2D

@onready var move_tiles = $MoveTiles
@onready var ground = $Ground

var move_tile_scene = preload("res://movement_tile.tscn")
var selected_unit = null
var current_team: String = "red"

var blocked_tiles = [
	Vector2i(5, 3),
	Vector2i(6, 3),
	Vector2i(7, 3),
	Vector2i(8, 3),
	Vector2i(9, 3),

	Vector2i(5, 4),
	Vector2i(6, 4),
	Vector2i(7, 4),
	Vector2i(8, 4),
	Vector2i(9, 4),

	Vector2i(5, 5),
	Vector2i(6, 5),
	Vector2i(7, 5),
	Vector2i(8, 5),
	Vector2i(9, 5),

	Vector2i(6, 8),
	Vector2i(7, 8),
	Vector2i(8, 8),

	Vector2i(6, 9),
	Vector2i(7, 9),
	Vector2i(8, 9)
]

func is_blocked_tile(tile_pos: Vector2i) -> bool:
	return tile_pos in blocked_tiles

func select_unit(unit) -> void:
	if unit.team != current_team:
		print("Not this team's turn")
		return

	if unit.has_acted:
		print("This unit already acted")
		return

	if selected_unit != null:
		selected_unit.set_selected(false)

	selected_unit = unit
	selected_unit.set_selected(true)

	if not unit.has_moved:
		show_move_range(unit)

	print("Current selected unit: ", selected_unit.name)

	show_move_range(unit)
	print("Current selected unit: ", selected_unit.name)
	
func can_move_to_tile(tile_pos: Vector2i, moving_unit) -> bool:
	if is_blocked_tile(tile_pos):
		return false
	
	if is_tile_occupied(tile_pos, moving_unit):
		return false
	
	return true

func show_move_range(unit) -> void:
	clear_move_tiles()

	var move_range = unit.move_range
	var origin = unit.grid_position

	for x in range(-move_range, move_range + 1):
		for y in range(-move_range, move_range + 1):
			if abs(x) + abs(y) <= move_range:
				var tile_pos = origin + Vector2i(x, y)

				if not can_move_to_tile(tile_pos, unit):
					continue

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
			unit.has_acted = false

	if current_team == "red":
		current_team = "grey"
		$p2.play()
		$HUD/Label.text = "Player 2"
		$HUD/ColorRect2.show()
		$HUD/ColorRect1.hide()
	else:
		current_team = "red"
		$p1.play()
		$HUD/Label.text = "Player 1"
		$HUD/ColorRect1.show()
		$HUD/ColorRect2.hide()

	print("Current turn: ", current_team)
	
func is_adjacent(pos1: Vector2i, pos2: Vector2i) -> bool:
	var dx = abs(pos1.x - pos2.x)
	var dy = abs(pos1.y - pos2.y)
	return dx + dy == 1
	
func try_attack(attacker, target) -> bool:
	if attacker.team == target.team:
		return false

	if not is_adjacent(attacker.grid_position, target.grid_position):
		print("Target is not adjacent")
		return false

	target.health -= 5
	print("Attacked ", target.name, " | HP:", target.health)

	if target.health <= 0:
		$death_sound.play()
		target.anim.play("die")
		await target.anim.animation_finished
		print(target.name, " defeated")
		check_win_condition()
		target.queue_free()

	return true

func check_win_condition() -> void:
	var red_exists = false
	var grey_exists = false

	for unit in $Units.get_children():
		if unit.health <= 0:
			continue

		if unit.team == "red":
			red_exists = true
		elif unit.team == "grey":
			grey_exists = true

	if not red_exists:
		print("Grey Wins!")
	elif not grey_exists:
		print("Red Wins!")
		
func is_tile_occupied(tile_pos: Vector2i, ignore_unit = null) -> bool:
	for unit in $Units.get_children():
		if unit == ignore_unit:
			continue
			
		if unit.grid_position == tile_pos:
			return true
		
	return false
