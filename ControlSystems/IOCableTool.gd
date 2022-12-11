

# for connecting io cables
# tools are treated as highest in hierarchy (signalled to, calling down)
# above managers

class_name IOCableTool
extends ShipBuilderTool


# FIELDS -----------------------------------------------------------------------


# a port has previously been selected, this is that port
var selected_port = null


# CALLBACKS --------------------------------------------------------------------


func _unhandled_input(event):
	
	# cancel
	if event.is_action_pressed("ui_cancel"):
		clear_selected_port()


# PRIVATE ----------------------------------------------------------------------


# -- SIGNAL INPUT LISTENING


# when ship clicked, see if block is io block and activate/listen
func on_ship_reported_clicked(ship, block):
	.on_ship_reported_clicked(ship, block)
	
	if !active: return
	
	# try get port
	# TODO blocks should all inherit or something
	var systems_manager = block.block_systems_manager
	if systems_manager == null: return
	var port_manager = systems_manager.get_system("port_manager")
	if port_manager == null: return
	
	print("CABLETOOL ACTIVATING BLOCK PORTS")
	
	# listen for ports on this block	
	port_manager.connect("port_button_pressed", self, "_on_listening_pressed")
	
	# tell block it's been clicked by the cable tool
	port_manager.tool_selected()


# called when a port that this tool is listening to (has selected) is selected
func _on_listening_pressed(port : IOPort, block : Block):
	
	# is the port available?
	if port.cable: return
	
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
	cable_manager = ship.ship_systems.get_system("io_cable_manager")
	
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
	clear_selected_port()
	return


# -- HELPERS / UI ENTRY POINTS


func clear_selected_port():
	selected_port = null