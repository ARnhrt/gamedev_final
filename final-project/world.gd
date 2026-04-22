extends Node2D

var selected_unit = null

@onready var move_tiles = $MoveTiles
@onready var ground = $Ground

var move_tile_scene = preload("res://movement_tile.tscn")

func select_unit(unit) -> void:
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
