
class_name QuitButton
extends Button


@export var save = true


func _ready():
	connect("pressed", Callable(self, "_on_pressed"))


func _on_pressed():
	
	if save: CompanyData.save_data()
	
	get_tree().quit()
