
# split an input
class_name PortSplitterBlock
extends PortBlockBase


# FIELDS ----------------------------------------------------------------------


@export var port_in_path : NodePath
@export var out_ports_paths # (Array, NodePath)

@onready var port_in = get_node(port_in_path)

# populated in ready
var out_ports = []



# CALLBACKS --------------------------------------------------------------------


func _ready():
	
	# populate out_ports
	for path in out_ports_paths: out_ports.append(get_node(path))


func _process(delta):
	_propagate_input()


# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------


func _propagate_input():
	for port in out_ports: port.data = port_in.data


# -- SUBSECTION


