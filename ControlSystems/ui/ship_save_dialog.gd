
# file dialog for saving ships


class_name ShipSaveDialog
extends FileDialog



# FIELDS ==========



# parent node for ships (TODO level in singleton?)
@export var level : Level

# TODO why doesn't dir path do this
@onready var root_path = "res://" + root_subfolder 



# PRIVATE ===========



func _on_dir_selected(dir):
	
	print("SAVER SAVING DIR: ", dir)
	print("file text: ", get_line_edit().text)
	
	hide()


func _on_file_selected(file):
	
	print("SAVER SAVING FILE: ", file)
	var id = get_line_edit().text
	var dir = root_path + "/" + current_dir
	
	level.current_ship.save_root(id, dir)
	
	hide()



func _on_show_requested():
	show()


func _on_hide_requested():
	hide()
