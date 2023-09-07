# level singleton for loading ships into the correct place in the nodetree

extends Node

@export var new_ship_path = "res://ShipBase/ShipBody.tscn"
@onready var ship_template = load(new_ship_path)
@onready var ship_loader = Ship_SaverLoader_GDS.new() # TODO temp

var loading_thread : Thread
var start_time

signal ship_loaded(ship)

func load_ship( ship_save : Resource, 
				target_parent : Node,
				subShip = false,
				position = Vector2.ZERO
				) -> Node2D:
	
	# load ship
	print("LOADING SHIP...")
	var ship = load(new_ship_path).instantiate()
	print("NEW SHIP BASE: ", ship)
	ship.position = position
	target_parent.add_child(ship)
	
	start_time = Time.get_ticks_msec()
	
	# threaded loading works, but with some werid behavior for subships et al.
	
	# loads from save onto new ship in thread
#	loading_thread = Thread.new()
#	loading_thread.start(self, "thread_load", ship_save)
	
	thread_load(ship, ship_save, subShip)
	
	# doing this here instead of in save res for flexibility
	ship.post_load_block_setup()
	
	return ship

func thread_load(ship, ship_save : Resource, subship = false):
	ship_loader.load_ship(ship, ship_save, subship)
	
	print("SHIP FINISHED LOADING: ", ship)
	print("SHIP LOADING TIME func: ", Time.get_ticks_msec() - start_time)
	emit_signal("ship_loaded", ship)

func _exit_tree():
	if (loading_thread != null): loading_thread.wait_to_finish()
