class_name PinBlock
extends Block

export var default_subShip = "pinblock_default"
export var default_pinHead = "PinHeadBase" 
# relative path from subship node

export var ships_folder = "res://Ships"
export var subShips_filepath = "/SubShips" # filepath from ship directory

var subShip = null
var pinHead = null
var pinJoint = null

# by default from exports - overwritten in load_in()
onready var subShip_name = default_subShip
onready var subShip_address = ships_folder + "/" + default_subShip
onready var pinHead_name = default_pinHead

var queue_pin = false

# communicates up to shipbody
signal subShip_pinned(subShip, pinBlock, pinHead)
signal subShip_removed(subShip, pinBlock, pinHead)

func _ready():
	._ready()
	
	pinJoint = $PinJoint2D
	
	print("loading!")

func on_added_to_grid(center_coord, block, grid):
	.on_added_to_grid(center_coord, block, grid)
	
	connect("subShip_pinned", shipBody, "on_new_subShip")
	connect("subShip_removed", shipBody, "on_subShip_removed")
	
	var pinHead = create_subship_pinhead()
	attach(pinHead)
	
	# listen for subship grid changes
	pinHead.connect("pin_grid_changed", self, "on_pin_grid_changed")

func on_removed_from_grid(center_coord, block, grid):
	.on_removed_from_grid(center_coord, block, grid)
	
	# TODO are you sure you want to delete this subship?
	# can return false here
	
	emit_signal("subShip_removed", subShip, self, pinHead)

func create_subship_pinhead() -> Node2D: # returns pinhead
	# ship
	var template = load(subShip_address + "/" + subShip_name + ".tscn")
	var ship = template.instance()
	ship.load_in(subShip_address)
	
	# pinhead
	var pinHead = ship.grid.get_node(pinHead_name)
	return pinHead

func attach(pinHead): 
	print("attaching pinhead")
	# should be placed on grid before attaching
	
	if !pinHead is PinHead:
		print("invalid pinHead")
		return false
	
	# setup subship
	var ship = pinHead.shipBody
	if !ship.has_method("is_shipBody"): # quack quack
		print("pinHead has invalid shipBody")
		return false
	subShip = ship
	add_child(subShip) # note this makes subgrid child of block
	subShip.position = Vector2(0,0)
	
	# setup pinhead (after ship placed in nodetree) 
	self.pinHead = pinHead
	pinHead_name = pinHead.name
	
	# TODO relative position for loaded subships
	
	subShip.angular_velocity = 1.0 # for shits
	queue_pin = true
	
	emit_signal("subShip_pinned", subShip, self, pinHead)
	return true

func pin_subShip():
	# TEST 
	print(subShip.position)
	
	reposition_subShip(pinHead)
	
	if (pinJoint is PinJoint2D):
		pinJoint.node_b = ""
		pinJoint.node_a = ""
		pinJoint.free()
	
	pinJoint = PinJoint2D.new()
	add_child(pinJoint)
	pinJoint.owner = self
	pinJoint.name = "PinJoint2D" # fine godot have it your way
	
	# refreshes 
	#pinJoint.disable_collision = !pinJoint.disable_collision
	#pinJoint.disable_collision = !pinJoint.disable_collision
	
	pinJoint.node_a = grid.anchor.get_path() # pin to grid anchor
	pinJoint.node_b = subShip.get_path()
	queue_pin = false
	print("subship physics pinned")

# pinhead reattaching ----------------------------------------------------------

func on_pin_grid_changed(pinHead):
	reattach(pinHead)
	pass

# reattaches to pinHead position (for shifting subship)
func reattach(pinHead):
	
	print("reattaching...")
	
	queue_pin = true

# redundant to natural movement of subship
func reposition_subShip(pinHead): 
	# first centers subship, (assuming subship is child)
	subShip.position = Vector2(0,0)
	
	# shifts subship along inverse of pinhead relative position vector 
	var from_subship = subShip.grid.position + pinHead.position 
	print("repos: ", from_subship)
	subShip.position -= from_subship

func reposition_subship_to_pinhead(pinHead):
	pass

func _physics_process(delta):
	if (queue_pin):
		pin_subShip()

# SAVING AND LOADING ===========================================================

func on_save_blocks(folder, ship_folder):
	# parent func called below
	
	# subship name
	# set before calling parent func, saving name to file
	subShip_name = "subShip_" + self.name
	
	# save subship
	subShip.save(subShip_name, ship_folder + subShips_filepath)
	
	# save self, storage
	.on_save_blocks(folder, ship_folder)

func load_in(folder, grid, ship_folder, old_name):
	.load_in(folder, grid, ship_folder, old_name)
	# storage loaded:
	# - subShip_name
	
	# instance and load subship
	subShip_address = ship_folder + subShips_filepath + "/" + subShip_name 


