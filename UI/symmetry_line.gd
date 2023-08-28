
# draws the line of symmetry for a grid

class_name SymmetryLine
extends Node2D



# FIELDS ==========



@export var grid : GridBase
@export var line : Line2D
@export var y_height = 500


var line_visible = true



# CALLBACKS ==========



func _ready():
	hide_line()



# PUBLIC ==========



func set_visibility(state):
	if state == false: hide_line()
	else: show_line()


func show_line():
	print("SYMMETRY SHOWING LINE")
	line_visible = true
	visible = true
	_set_line()


func hide_line():
	print("SYMMETRY HIDING LINE")
	line_visible = true
	visible = false



# PRIVATE ===========



func _set_line():
	var x_coord = grid.x_symmetry_line
	var x = grid.get_pointFromGrid(Vector2(x_coord, 0)).x
	line.clear_points()
	line.add_point(Vector2(x,y_height))
	line.add_point(Vector2(x, -y_height))
	
#	print("symmetry grid visible? ", grid.visible)
#	print("SYMMETRY LINE: ", line.global_position, ", ", line.points, ", ", visible)


func _on_symmetry_set(state):
	set_visibility(state)
