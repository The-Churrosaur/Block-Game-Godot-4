
# base class for ship editor tools


class_name ShipBuilderTool
extends Node2D



# FIELDS ==========



@export_category("Tool info")
@export var display_name = "Default Tool"
@export var description = "you can't do anything here"

@export_category("Cursor")
@export var custom_cursor : Resource
@export var cursor_shape : Input.CursorShape
@export var cursor_sprite : Sprite2D

@export_category("")
@export var tool_id = "default_tool"
@export var active = false


# injected by manager
var level : Level = null

# injected by manager
var current_ship : ShipBody = null



# CALLBACKS ==========



func _ready():
	pass


func _input(event):
	pass


func _process(delta):
	
	# backup cursor sprite 
	# currently the engine cursor change only works for the nested control 
	# layer that calls it

	if cursor_sprite != null:
		cursor_sprite.global_position = get_global_mouse_position()


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
	
	if cursor_sprite != null: cursor_sprite.visible = true
	Input.set_custom_mouse_cursor(custom_cursor, cursor_shape)
	Input.set_default_cursor_shape(cursor_shape)


# override me
func deactivate_tool():
	active = false
	
	if cursor_sprite != null: cursor_sprite.visible = false
	Input.set_custom_mouse_cursor(null)



# PRIVATE ===========



func _on_toggle_input(state : bool):
	if state == true: activate_tool()
	if state == false: deactivate_tool()


# listens for ships self-reporting being clicked
func on_ship_reported_clicked(ship, block):
#	print("BUILDER TOOL: ship reported clicked, ", ship)
	pass


