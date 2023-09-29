
# base class for game scenes

class_name Level
extends Node2D



# FIELDS ==========



signal new_ship_selected(ship)

var current_ship : ShipBody



# PUBLIC ==========



# saves self and all children as a packed scene at location
func save_level(filepath : String):
	
	_own_all_nodes()
	
	var packed = PackedScene.new()
	packed.pack(self)
	
	ResourceSaver.save(packed, filepath)



# PRIVATE ==========




# sets owner of all children to self
func _own_all_nodes():
	_own_children(self)


# recursive helper
func _own_children(node : Node):
	for child in node.get_children():
		_own_children(child)
		child.owner = self
