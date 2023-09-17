class_name TestScene
extends Level

@onready var test_grid

@onready var io_tool = $IOPicker
@onready var selector_tool = $ShipSelector
@onready var cable_tool = $IOCableTool
@onready var fuel_tool = $FuelCableTool

@export var io_tool_button : Button
@export var selector_tool_button : Button
@export var cable_tool_button : Button

@onready var camera = $CameraBase

var subShip = 0
var block_facing = 0
var test_block = null
var display_block = null
var block_template = null

signal ship_clicked(ship, block)

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# initial ship
	var packed = load("res://ShipBase/ShipBody.tscn")
	var ship = packed.instantiate()
	on_new_ship(ship)
	select_ship(ship)
	
	current_ship.position = Vector2(500,500)
	
	# setup tools
	setup_tools()
	
	# connect buttons
	io_tool_button.connect("toggled", Callable(io_tool, "on_toggle_input"))
	selector_tool_button.connect("toggled", Callable(selector_tool, "on_toggle_input"))

func select_ship(ship):
	
	# attempt to switch to selected ship
	if ship == current_ship:
		print("scene: current ship selected")
		return
	elif !(ship is ShipBody):
		print("ship clicked: no shipbody returned")
		return
	
	ship.deselect_ship()
	
	current_ship = ship
	print("hooking up ship to testscene: ", ship)
	test_grid = ship.grid
	
	
	# look at ship
	camera.set_target(ship)
	
	ship.select_ship()
	
	emit_signal("new_ship_selected", ship)


func on_new_ship(ship : RigidBody2D, select = true):
	
	add_child(ship)
	ship.freeze = true
	print("CONNECTING SIGNALS ", ship)
	ship.connect("on_clicked", Callable(self, "on_ship_clicked"))
	ship.connect("new_subShip", Callable(self, "on_new_subShip"))
	ship.input_pickable = true
	ship.editor_mode = true
	
#	ship.mode = RigidBody2D.MODE_KINEMATIC
	
	if select: 
		select_ship(ship)
	
#	ship.rotation = PI
	
	await get_tree().create_timer(0.5).timeout

func on_new_subShip(ship, subShip, pinBlock):
	print("TESTSCENE NEW SUBSHIP")
	on_new_ship(subShip, false)

func setup_tools():
	
	# TODO some tool manager?
	io_tool.setup(self)
	selector_tool.setup(self)
	selector_tool.connect("new_ship_selected", Callable(self, "on_selector_new_ship"))
	cable_tool.setup(self)
	cable_tool.active = true
	fuel_tool.setup(self)
	fuel_tool.active = true

func on_selector_new_ship(ship):
	select_ship(ship)

func on_ship_clicked(shipBody, block, event):
	print("scene: shipclicked")
	emit_signal("ship_clicked", shipBody, block)
	
#	select_ship(shipBody)

func on_io_tool_button_toggled(state):
	io_tool.set_active(state)

func on_block_select_button_pressed(block):
	if block is PackedScene:
		block_template = block
		if display_block is Block:
			display_block.queue_free()
		display_block = block_template.instantiate()
		add_child(display_block)

func _process(delta):
	
	pass
	
#	if (Input.is_action_just_pressed("ui_accept")):
#		current_ship.linear_velocity += Vector2(10,0)
