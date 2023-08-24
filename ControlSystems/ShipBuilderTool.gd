class_name ShipBuilderTool
extends Node2D

# unique identifier
@export var tool_id = "default_tool"

@export var active = false


# injected by manager
var level : Level = null

# injected by manager
var current_ship : ShipBody = null


# call me ;)
func setup(current_scene):
	pass
	# redundant to manager here because lazy

func on_toggle_input(state : bool):
	if state == true: activate_tool()
	if state == false: deactivate_tool()

# override me
func activate_tool():
	active = true
	print("tool set: ", name, ", ", active)

# override me
func deactivate_tool():
	active = false

# listens for ships self-reporting being clicked
func on_ship_reported_clicked(ship, block):
#	print("BUILDER TOOL: ship reported clicked, ", ship)
	pass

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
