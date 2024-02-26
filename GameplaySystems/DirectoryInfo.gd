# autoload for user folder management

extends Node

@export var parent_dir = "user://"
@export var shipDirectory_user = "ships"
@export var saveDirectory_user = "save"
@export var exampleShips_user = "ships/examples"


func _ready():
	
	# make dirs if missing 
	var dir = DirAccess.open(parent_dir)
	
	if !dir.dir_exists(shipDirectory_user): dir.make_dir(shipDirectory_user)
	if !dir.dir_exists(saveDirectory_user): dir.make_dir(saveDirectory_user)
	
	# prompts the example ship loader
	if !dir.dir_exists(exampleShips_user): 
		dir.make_dir(exampleShips_user)
		ExampleShipPreloader.move_ships()
	
	# move example ships into user dir
	
	


func get_ship_directory():
	return parent_dir + shipDirectory_user

func get_save_directory():
	return parent_dir + saveDirectory_user

func get_examples_dir():
	return parent_dir + exampleShips_user


