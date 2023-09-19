

class_name ToolDescriptorTab
extends MarginContainer


@export var description : Label


func set_description(tool : ShipBuilderTool):
	name = tool.display_name
	description.text = tool.description
