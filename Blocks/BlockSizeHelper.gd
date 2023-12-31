@tool

# tool helper for block grid sizing
# injects the tilemap into the block size_grid

class_name BlockSizeHelper
extends TileMap


# FIELDS ----------------------------------------------------------------------


@export var block_path : NodePath = ".."

var block


# CALLBACKS --------------------------------------------------------------------


func _ready():
	
	# delete self on ingame run
	if !Engine.is_editor_hint():
		queue_free()
	
	pass


func _process(delta):
	
	_on_tilemap_changed()
	
	pass


func _input(event):
#	if event.is_action_pressed("ui_lclick") or event.is_action_pressed("ui_rclick"):
#		_on_tilemap_changed()
	pass

# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------


func _on_tilemap_changed():
	
	block = get_node_or_null(block_path)
#	print(block_path, block)
	
	if block == null: 
		print("size helper: block null")
		return
	
	# this keeps giving false negatives 
	
#	if !block.get("size_grid"): 
#		print("no size grid")
#		return
	
	block.size_grid = get_used_cells(0)
	
#	print("cells: ", get_used_cells())
#	print("size grid: ", block.size_grid)


# -- SUBSECTION


