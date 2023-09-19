class_name TestScene
extends Level

@onready var test_grid


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


func on_selector_new_ship(ship):
	select_ship(ship)


func on_ship_clicked(shipBody, block, event):
	print("scene: shipclicked")
	emit_signal("ship_clicked", shipBody, block)
	
#	select_ship(shipBody)
