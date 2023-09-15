
# sets  (fresh) companydata with lineedit name and starts game

class_name NewSaveWindow
extends PopupPanel


# FIELDS ==========


@export var line_edit : LineEdit
@export var load_scene : PackedScene


# PRIVATE ==========


func _on_line_entered(text):
	CompanyData.reset_data()
	CompanyData.save_name = text
	hide()
	get_tree().change_scene_to_packed(load_scene)


func _on_hide_requested():
	hide()


func _on_show_requested():
	show()
