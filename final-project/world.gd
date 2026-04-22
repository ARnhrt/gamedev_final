extends Node2D


var selected_unit = null
@onready var move_tiles = $MoveTiles
var move_tile_scene = preload("res://movement_tile.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func select_unit(unit) -> void:
	if selected_unit != null:
		selected_unit.set_selected(false)

	selected_unit = unit
	selected_unit.set_selected(true)

	print("Current selected unit: ", selected_unit.name)	

func show_move_range(unit):
	clear_move_tiles()

	var range = unit.move_range
	var origin = unit.grid_position

	for x in range(-range, range + 1):
		for y in range(-range, range + 1):

			# simple diamond shape (Manhattan distance)
			if abs(x) + abs(y) <= range:
				var tile_pos = origin + Vector2i(x, y)

				spawn_move_tile(tile_pos)
