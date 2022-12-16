
# holds cables for tracking and serialization reasons
# reconstructs cables and injects references
class_name IOCableManager
extends ShipSystem


# FIELDS -----------------------------------------------------------------------


# resource for instantiation
export var cable_scene : PackedScene


# holds the cable objects
# cable -> bool
onready var cables = {}


# CALLBACKS --------------------------------------------------------------------


# TODO think about how to trigger this more regularly
func _physics_process(delta):
	_transmit_cable_data()


# PUBLIC -----------------------------------------------------------------------


# -- SAVING LOADING


# called by manager -> ship
# ["cables"] -> array of cables, each element is : {sender_port, receiver_port} 
# each port is {"ship" -> name, "block" -> coord, "port" -> id}
func save_data() -> Dictionary:
	.save_data()
	
	var save_cables = []
	
	for cable in cables.keys():
		var cable_dict = {}
		cable_dict["sender_port"] = _get_address(cable.sender_port)
		cable_dict["receiver_port"] = _get_address(cable.receiver_port)
		save_cables.append(cable_dict)
	
	var dict = {}
	dict["cables"] = save_cables
	return dict


# load cables from dictionary
# called by manager -> ship
func load_data(dict):
	.load_data(dict)
	
	for cable in dict["cables"]:
		print("CABLE MANAGER LOADING CABLE: ", cable)
		_new_from_address(cable)


# -- ADD REMOVE CABLES


# insantiate new cable and add to dict
func new_cable(sender_port, receiver_port):
	
	if (sender_port == null) or (receiver_port == null):
		print("CABLEMANAGER, INVALID CABLE")
		return 
	
	var cable = cable_scene.instance()
	cable.sender_port = sender_port
	cable.receiver_port = receiver_port
	
	cables[cable] = true
	
	print("CABLEMANAGER NEW CABLE")


func remove_cable(cable):
	cables.erase(cable)


# PRIVATE ----------------------------------------------------------------------


# -- SAVING LOADING


# calls new_cable after finding ports from addresses
# takes cable dict
func _new_from_address(dict):
	
	print("CABLEMANAGER PORT ADDRESSES: ", dict["sender_port"])
	
	var sender_port = _get_port(dict["sender_port"])
	var receiver_port = _get_port(dict["receiver_port"])
	
	print("CABLEMANAGER PORTS FROM ADDRESS: ", sender_port, ", ", receiver_port)
	
	new_cable(sender_port, receiver_port)


# from port address dict
func _get_port(dict):
	
	print ("CBM SHIPBODY: ", shipBody)
	print ("CBM PORT SHIP ID: ", dict["ship"])
	var ship = shipBody.get_ship_in_tree(dict["ship"])
	print("PORT SHIP FOUND: ", ship)
	if ship == null: return null
	
	print ("CBM BLOCK: ", dict["block"])
	print (ship.grid.block_dict)
	var block = ship.get_block(dict["block"])
	print("CBM BLOCK: ", block)
	if block == null: return null
	
	var port_manager = block.block_systems_manager.get_system("port_manager")
	return port_manager.get_port(dict["port"])


# get address from port
# {"ship" -> ship_id, "block" -> coord, "port" -> id}
func _get_address(port : IOPort) -> Dictionary:
	
	var manager = port.manager
	var block = manager.block
	var ship = block.shipBody 
	
	var dict = {}
	
	dict["ship"] = ship.ship_id
	dict["block"] = block.center_grid_coord
	dict["port"] = port.port_id
	
	return dict


# -- CABLE DATA TRANSMISSION


# transmits data on all cables
func _transmit_cable_data():
	for cable in cables.keys():
		cable.send_data()
