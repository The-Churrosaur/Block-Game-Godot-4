
# building tool manager
# stores and delegates tool usage
# also manages currently selected ship

class_name ToolManager
extends Node



# FIELDS ----------------------------------------------------------------------


# tools
@export var tools : Array[ShipBuilderTool]

# level
@export var level : Level # TODO


# selected ship to work on
var selected_ship : ShipBody



# CALLBACKS --------------------------------------------------------------------



func _ready():
	
	# inject data into tools (scene, clicked signal)
	for tool in tools: 
		tool.level = level
		level.connect("ship_clicked", Callable(tool, "on_ship_reported_clicked"))
	
	# listen for new ships
	level.connect("new_ship_selected", Callable(self, "_on_new_ship_selected"))



func _process(delta):
	pass



# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------



func _on_new_ship_selected(ship):
	selected_ship = ship
	
	# inject into tools
	for tool in tools:
		tool.current_ship = ship



# -- SUBSECTION


