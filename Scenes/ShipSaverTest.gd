extends LineEdit

func _ready():
	
	connect("text_submitted", Callable(self, "on_text_entered"))
	
	pass

func on_text_entered(text):
	owner.current_ship.save_root(text)
#
#	var ship = owner.main_ship.ship_save.loadShip("res://ShipBase/ShipBody.tscn", "res://Blocks/")
#	owner.add_child(ship)
#	owner.test_ship = ship
#	owner.test_grid = ship.grid
#	owner.main_ship = ship
	pass
