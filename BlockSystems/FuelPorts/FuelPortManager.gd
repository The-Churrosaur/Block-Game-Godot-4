
# inherits from portmanager
# track fuelports

class_name FuelPortManager
extends PortManager


# FIELDS -----------------------------------------------------------------------



# CALLBACKS --------------------------------------------------------------------

func _ready():
	super._ready()
	
	print("fuelports: ", ports)


# PUBLIC -----------------------------------------------------------------------


func tool_selected():
	super.tool_selected()
	
	print("fuelport: tool selected. ports: ", ports)


# PRIVATE ----------------------------------------------------------------------

