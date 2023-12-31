# assumption: connections are always from one A to one B 
# splits etc. done by specific boxes, create new connections
# manager is invisible  to ioboxes, handles signal propagation

class_name IOManager
extends Node

@export var ship_path : NodePath
@export var propagate_every_frame = true
#TODO variable timer for propagation
@onready var ship = get_node_or_null(ship_path)

# dictionary of connections
# output -> input
# outputs and inputs are arrays of form [coordinate, port, subship]
@onready var connections = {}


func _ready():
	pass


func _process(delta):
	if propagate_every_frame: propagate()


func setup(this_ship):
	if ship == null:
		ship = this_ship
	ship.grid.connect("block_added", Callable(self, "block_added"))
	ship.grid.connect("block_removed", Callable(self, "block_removed"))


# manager goes through connections - retrieving outputs and injecting to inputs
func propagate():
	propagate_all_connections()


func propagate_all_connections():
	
#	print(connections)
	
	for output in connections.keys():
		var input = connections[output]
		
		var in_coord = input[0]
		var in_port = input[1]
		var in_ship = ship.get_ship_in_tree(input[2])
		
		var out_coord = output[0]
		var out_port = output[1]
		var out_ship = ship.get_ship_in_tree(output[2])
		# TODO this is slow - stash results?
		
		if (in_ship == null) or (out_ship == null): 
#			print("ships are null, fallthrough")
			continue
		
		# retrieve output value
		var out_block = out_ship.get_block(out_coord)
		if out_block == null:
			remove_connection(out_coord, out_port, out_ship, 
								in_coord, in_port, in_ship)
			continue
		var value
		if out_block.io_box:
			value = out_block.io_box.get_output(out_port)
		
		# inject input value
		# get iobox
		# set value
		var in_block = in_ship.get_block(in_coord)
		if in_block == null:
			remove_connection(out_coord, out_port, out_ship,
							 in_coord, in_port, in_ship)
			continue
		if in_block.io_box:
			in_block.io_box.set_input(in_port, value)
#			print("injecting into ", in_block, in_block.io_box)
		
#		print("fallthrough")


# can be called by blocks to propagate output to any connections
# TODO update with multigrid
func output(coord, port, value) -> bool:
	if connections.has([coord, port]):
		var in_coord = connections[[coord, port]][0]
		var in_port = connections[[coord, port]][1]
		# get iobox
		# set value
		var block = ship.get_block(in_coord)
		if block.io_box:
			block.io_box.set_input(in_port, value)
			return true
	return false


# add cut connections
func add_connection(output_coord, output_port, out_ship,
					input_coord, input_port, in_ship): 
	connections[[output_coord, output_port, out_ship]] = [input_coord, input_port, in_ship]
	print("connection added: ", connections)

func remove_connection(output_coord, output_port, out_ship,
						input_coord, input_port, in_ship):
	connections.erase([output_coord, output_port, out_ship])

# TODO should it be the block's responsibility to delete connections on death?


# listens to grid
func block_added(coord, block, grid, update_com):
	if block is IOBlock: # wary of circular dependency
		block.io_box.manager = ship.io_manager

func block_removed(coord, block, grid, update_com):
	#TODO delete all involved connections - 
	pass


# =======================================
# TEMP generate ui for visualizing/deleting connections
# bleaudasughdaf


@export var string_template : PackedScene


# generate strings and buttons from connection list
func spawn_strings():
	
	var string
	for connection in connections.keys():
		
		string = string_template.instantiate()
		
		string.manager = self
		string.out_coord = connection[0]
		string.out_port = connection[1]
		string.out_ship = connection[2]
		
		string.out_block = ship.get_block(connection[0])
		string.in_block = ship.get_block(connections[connection][0])


# update these from positions (call every tick)
