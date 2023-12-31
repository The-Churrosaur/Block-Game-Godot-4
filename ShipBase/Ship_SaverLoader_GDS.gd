# GDSCRIPT replacement for nativescript loader/saver
# takes location and creates serialized folder
# build ship into skeleton

# manager for resource (old saver was encapsulated resource with own functions)
# resource defined in ShipSave_Resource.gd

# TODO should this be a singleton or scene localized or what

class_name Ship_SaverLoader_GDS
extends Node2D

# default filepath to load blocks
@export var blocks_directory = "res://Blocks/"

# returns file
func save(ship : Node2D, name : String, directory : String) -> String:
	
	# manage resource
	var save_resource = ShipSaveResource.new()
	var resource_types = save_resource.block_types
	var resource_blocks = save_resource.blocks
	
	# EXTRACT SHIP DATA
	
	# get grid dict
	var grid = ship.grid
	if grid == null: return "ERROR"
	var grid_dict = grid.blocks_id
	
	print("shipsave saving! " + name + " in: " + directory)
	
	# NAVIGATE TO DIRECTORY
	
	# navigate directory
	var dir = DirAccess.open(directory)

	# check if file already exists, append name
	if dir.dir_exists(name):
	
		print("Save already exists, renaming")
		name = name + "_1"
		# TODO properly append numbers use regex lol
		# TODO this will break things looking for subship name
		# TODO TODO TODO (or just leave it to users)
	
	# make folder
	dir.make_dir(name)
	
	# make subship folder 
	dir.change_dir(name)
	dir.make_dir("SubShips") # TODO case issues? 

	# create file
	var file = directory + name + "/" + name + ".tres"
	
	# UPDATE RESOURCE FROM SHIP

	# RECURSIVELY SAVE SUBSHIPS
	save_subShips(ship, directory + name + "/SubShips/")
	
	# save blocks
	# TODO appending to array may be slow - consider resizing in advance
	
	# get blocks (nodes)
	var blocks = grid_dict.values()
	# iterate through dict
	for block in blocks:
		# get save data from node
		var block_data = block.get_save_data()
		# store block
		resource_blocks.append(block.get_save_data()) # save data from node
		# store type and address
		resource_types[block_data["type"]] = block_data["address"]
	
	# get ship data
	save_resource.ship_data = ship.get_save_data()
	
	# SAVE RESOURCE TO DISK
	
	print("saving to disc: " + file)
	ResourceSaver.save(save_resource, file)
	
	return file


# recursive helper
func save_subShips(ship : Node2D, directory : String):
	
	# iterate through subships, save
	
	# get dict
	var subShip_dict = ship.subShips
	if subShip_dict.is_empty():
		print("Ship saver: no subships")
		return
	
	# get ships
	var subShips = subShip_dict.values()
	
	# iterate
	for subShip in subShips:
		
		# don't re-save self
		if subShip.name == ship.name : continue
		
		# call save with [ship.name, file]
		print("saving subship: " + subShip.name)
		subShip.save(subShip.name, directory)


# load ship
func load_ship(	ship_base : RigidBody2D, 
				save_resource : Resource, 
				subShip = false 
				) -> Node2D:
	
	# just for safety
	ship_base.freeze = true
	
	# populate dict with loaded block scenes, will instantiate from dict later
	var block_factory = {}
	
	print("SAVER LOADING RESOURCE: ", save_resource)
	
	# iterate through blocktypes from resource and populate
	var block_types = save_resource.block_types
	for type in block_types.keys() :
		
		# get address
		var address
		
		# backwards compat.
		if block_types[type] is bool:
			address = blocks_directory + type + ".tscn"
		
		# updated way using filenames
		elif block_types[type] is String:
			address = block_types[type]
		
		print("saver loading blockres:")
		print(type)
		print(address)
		
		block_factory[type] = ResourceLoader.load(address)
		
		# TODO unnecessary instance
#		print("saver blockresource added: " + blockRes.instance().get_name())
	
	print("BLOCK FACTORY: ")
	print(block_factory)
	
	# get grid
	var grid = ship_base.grid
	print("block grid retrieved")
	
	# add blocks to ship
	for block_dict in save_resource.blocks :
		
		# TRANSFER OVER BLOCK FIELDS
		
#		print("block dict retrieved")
		
		# instance block from resources
		var block_name = block_dict["type"]
		
		assert(block_name != "Block", "Block subtype is default, rename block")
		
		var block = block_factory[block_name].instantiate()
		
		# add all keys as fields back to block 
		# if applicable field exists
		
		for field_name in block_dict.keys() :
			
			# Godot::print("setting block field: " + field_name)
			block.set(field_name, block_dict[field_name]) # fails silently for special keys
			# Godot::print(block->get(field_name))
		
		# ADD BLOCK TO GRID
		
		if grid == null : print("grid is null") # let it crash
		
		# needed specifically for placement
		var name = block_dict["type"]
		var pos = block_dict["pos"]
		var facing = block_dict["facing"]
		
		# block, pos, facing, check collision, check com
		grid.add_block(block, pos, facing, false, false)
		
		# RESTORE BLOCK DATA
		
		block.load_saved_data(block_dict)
	
	# HANDLE SHIP SAVE DATA
	
	# set position from data
	var displacement = save_resource.ship_data["displacement"]
	print("grid displacement: ", displacement)
	grid.set_position(displacement)
	print("grid position: ", grid.get_position())
	
	ship_base.load_saved_data(save_resource.ship_data)
	
	# unfreeze
	ship_base.freeze = false
	
	# return built ship
	return ship_base
