extends Level

@onready var camera = $CameraBase


func _ready():
	pass


func on_new_ship(ship):
	
	if is_instance_valid(current_ship): current_ship.deselect_ship()
	
	current_ship = ship
	ship.select_ship()
	
	camera.set_target(ship)
	camera.zoom_to(Vector2.ONE, 5)
