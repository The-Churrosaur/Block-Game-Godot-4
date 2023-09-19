
# base class for ship editor tools


class_name ShipBuilderTool
extends Node2D



# FIELDS ==========

@export_category("Tab Labels")
@export var display_name = "Default Tool"
@export var description = "you can't do anything here"


@export_category("")
# unique identifier
@export var tool_id = "default_tool"
@export var active = false


# injected by manager
var level : Level = null

# injected by manager
var current_ship : ShipBody = null



# CALLBACKS ==========




# PUBLIC ==========



# attempts to manually find ships at position
func find_ships_at(global_pos) -> Array: 
	var hits = []
	var state = get_world_2d().direct_space_state
	var query_params = PhysicsPointQueryParameters2D.new()
	query_params.position = global_pos
	var intersections = state.intersect_point(query_params)
	print("Selector physics intersections: ", intersections)
	for hit in intersections:
		print("physics intersection hit!: ", hit)
		if hit["collider"] is ShipBody: hits.append(hit["collider"])
	return hits


# override me
func activate_tool():
	active = true
	print("tool set: ", name, ", ", active)

# override me
func deactivate_tool():
	active = false



# PRIVATE ===========



func _on_toggle_input(state : bool):
	if state == true: activate_tool()
	if state == false: deactivate_tool()


# listens for ships self-reporting being clicked
func on_ship_reported_clicked(ship, block):
#	print("BUILDER TOOL: ship reported clicked, ", ship)
	pass


