extends Node

# reeee

@export var ships : Array[Resource]
@export var names : Array[String]


func move_ships():
	
	print("moving ships:")
	
	var dir = DirectoryInfo.get_examples_dir()
	
	for i in ships.size():
		var ship = ships[i]
		var ship_name = names[i]
		var file = dir + "/" + ship_name + ".tres"
		print(file)
		ResourceSaver.save(ship, file)
