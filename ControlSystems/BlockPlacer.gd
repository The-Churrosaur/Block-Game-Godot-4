
# primary ship building tool


class_name BlockPlacer
extends ShipBuilderTool



# FIELDS ===========



@export var block_template : PackedScene


# also controls rotation
var display_block : Block



# CALLBACKS ===========


func _ready():
	
	# testing
	_on_new_palette(block_template)


func _input(event):
	
	# process input if tool is active
	
	if !active: return
	
	if event.is_action_pressed("ui_lclick"):
		_place_block()
	if event.is_action_pressed("ui_rclick"):
		_remove_block()
	if event.is_action_pressed("ui_cancel"):
		_cancel_block()
	
	if event.is_action_pressed("ui_right"):
		_rotate_block_right()
	if event.is_action_pressed("ui_left"):
		_rotate_block_left()



func _process(delta):
	
	# move display block
	if display_block != null:
		display_block.global_position = get_global_mouse_position()



# PRIVATE ============


func _on_new_palette(template : PackedScene):
	
	block_template = template
	
	# sets display block
	if display_block is Block:
		display_block.queue_free()
	display_block = block_template.instantiate()
	add_child(display_block)


func _place_block():
	
	if block_template == null: return
	
	var block = block_template.instantiate()
	var facing = 1
	if display_block != null: facing = display_block.block_facing
	current_ship.grid.add_block_at_point(block, get_global_mouse_position(), facing)


func _remove_block():
	current_ship.grid.remove_block_at_point(get_global_mouse_position())


func _cancel_block():
	
	if display_block == null: return
	display_block.queue_free()
	display_block = null
	block_template = null


func _rotate_block_left():
	if display_block != null:
		display_block.rotate_facing_left()


func _rotate_block_right():
	if display_block != null:
		display_block.rotate_facing_right()
