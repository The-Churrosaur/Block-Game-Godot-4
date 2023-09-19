

# for connecting io cables
# tools are treated as highest in hierarchy (signalled to, calling down)
# above managers

class_name IOCableTool
extends ShipBuilderTool


# FIELDS -----------------------------------------------------------------------


# asks blocksystem manger for port system
@export var port_system_id = "port_manager"

# asks shipsystem manager for cable system
@export var cable_system_id = "io_cable_manager"

# for drawing
@onready var line = $Line2D

# a port has previously been selected, this is that port
var selected_port = null

# keeps track of all ports the tool can currently access
var port_managers : Array[PortManager]


# CALLBACKS --------------------------------------------------------------------


func _unhandled_input(event):
	
	# cancel
	if event.is_action_pressed("ui_cancel"):
		_clear_selected_port()


func _process(delta):
	
	# line
	_draw_helper_line()



# PRIVATE ----------------------------------------------------------------------



func activate_tool():
	super.activate_tool()
	find_all_grid_ports()
	activate_all_ports()
	show_cables()


func deactivate_tool():
	super.deactivate_tool()
	deactivate_all_ports()
	hide_cables()


# searches the ship for all grid ports and adds them (linear search)
# eh TODO think about
func find_all_grid_ports():
	
	port_managers.clear()
	
	var ships = current_ship.get_all_ships_in_tree()
	for ship in ships:
		var blocks = ship.grid.blocks_id.values()
		for block in blocks:
			_try_add_port_manager(block)


func activate_all_ports():
	for manager in port_managers: _activate_ports(manager)


func deactivate_all_ports():
	for manager in port_managers: _deactivate_ports(manager)


func show_cables():
	if current_ship == null: return
	var ships = current_ship.get_all_ships_in_tree()
	for ship in ships:
		var cable_manager : IOCableManager 
		cable_manager = ship.ship_systems.get_system(cable_system_id)
		cable_manager.show_cables()


func hide_cables():
	if current_ship == null: return
	var ships = current_ship.get_all_ships_in_tree()
	for ship in ships:
		var cable_manager : IOCableManager 
		cable_manager = ship.ship_systems.get_system(cable_system_id)
		cable_manager.hide_cables()


# -- SIGNAL INPUT LISTENING


# when ship clicked, see if block is io block and activate/listen
func on_ship_reported_clicked(ship, block):
	super.on_ship_reported_clicked(ship, block)
	
	print("CABLETOOL REGISTERING CLICK")
	
	if !active: return


# called when a port that this tool is listening to (has selected) is selected
func _on_listening_pressed(port : IOPort, block : Block):
	
	# if no port selected, new trail
	if selected_port == null: 
		selected_port = port
		print("CABLETOOL PORT SELECTED")
		# drawing
		return
	
	# else try to connect cables
	
	# get port's ship's cablemanger
	var ship = block.shipBody
	var cable_manager : IOCableManager 
	cable_manager = ship.ship_systems.get_system(cable_system_id)
	
	# call connection
	
	# sender is stored, new port is receiver
	if selected_port.is_output and port.is_input: 
		cable_manager.new_cable(selected_port, port)
	
	# new port is sender, receiver is stored
	elif port.is_output and selected_port.is_input:
		cable_manager.new_cable(port, selected_port)
	
	# else invalid connection
	else:
		print("CABLETOOL INVALID PORT")
		return
	
	# cleanup
	# cleanup drawing
	_clear_selected_port()
	return


# -- HELPERS / UI ENTRY POINTS


# tries to find port manager, adds to manager list, returns manager or null
func _try_add_port_manager(block : Block) -> PortManager:
	
	var systems_manager = block.block_systems_manager
	if systems_manager == null: return null
	var port_manager = systems_manager.get_system(port_system_id)
	if port_manager == null: return null
	else:
		
		# appends to list
		port_managers.append(port_manager) 
		return port_manager


# activates manager's ports
func _activate_ports(port_manager : PortManager):
	
	print("CABLETOOL ACTIVATING BLOCK PORTS: ", port_manager.block)
	
	# listen for ports on this block	
	port_manager.connect("port_button_pressed", Callable(self, "_on_listening_pressed"))
	
	# tell block it's been clicked by the cable tool
	port_manager.tool_selected()


# deactivates manager's ports
func _deactivate_ports(port_manager : PortManager):
	
	print("CABLETOOL CLOSING BLOCK PORTS: ", port_manager.block)
	port_manager.tool_deselected()



func _draw_helper_line():
	
	# draw line
	if selected_port == null:
		line.visible = false
	else:
		line.visible = true
		line.set_point_position(0, selected_port.global_position)
		line.set_point_position(1, get_global_mouse_position())


func _clear_selected_port():
	selected_port = null



