
# file dialog for loading ships


class_name ShipLoadDialog
extends FileDialog



# FIELDS ==========



# parent node for ships (TODO level in singleton?)
@export var level : Level



# PRIVATE ===========



func _on_dir_selected(dir : String):
	
	# get resource from dir
	var res = ResourceLoader.load(dir)
	print("ship save loaded: ", dir)
	
	if !res: 
		print("invalid load path")
		deselect_all()
		return
	
	var ship = ShipLoader.load_ship(res, level, false, Vector2(650,200))
	print("SCENE LOADED NEW SHIP")
	level.on_new_ship(ship)
	
	print("grid position: ", ship.grid.position)
	
	hide()


func _on_file_selected(file):
	
	var res = ResourceLoader.load(file)
	print("ship save loaded: ", file)
	
	if !res: 
		print("invalid load path")
		deselect_all()
		return
	
	var ship = ShipLoader.load_ship(res, level, false, Vector2(650,200))
	print("SCENE LOADED NEW SHIP")
	level.on_new_ship(ship)
	
	print("grid position: ", ship.grid.position)
	
	hide()



func _on_show_requested():
	show()


func _on_hide_requested():
	hide()
