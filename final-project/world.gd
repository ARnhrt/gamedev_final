extends Node2D


var selected_unit = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func select_unit(unit) -> void:
	if selected_unit != null:
		selected_unit.set_selected(false)

	selected_unit = unit
	selected_unit.set_selected(true)

	print("Current selected unit: ", selected_unit.name)	
