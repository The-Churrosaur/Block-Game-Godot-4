
# for selecting shipbuilding tools


class_name ShipToolSelector
extends TabContainer


 
# FIELDS ==========



# index corresponds with tab index
@export var tools : Array[ShipBuilderTool]


@export_category("Tabs")
@export var tab_template : PackedScene



# CALLBACKS ==========



func _ready():
	
	# create tabs
	for tool in tools:
		var tab = tab_template.instantiate()
		tab.set_description(tool)
		add_child(tab)



# PRIVATE ==========



func _on_tab_changed(tab):
	for tool in tools : tool.deactivate_tool()
	tools[tab].activate_tool()
