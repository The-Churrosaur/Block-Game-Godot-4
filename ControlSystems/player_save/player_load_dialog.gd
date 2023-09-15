
# loads companydata and loads game


class_name PlayerLoadDialog
extends FileDialog



# FIELDS ==========


@export var load_scene : PackedScene


# PRIVATE ===========


func _on_file_selected(filepath):
	CompanyData.load_data(filepath)
	hide()
	get_tree().change_scene_to_packed(load_scene)


func _on_show_requested():
	show()
