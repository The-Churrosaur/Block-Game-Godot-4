
# DISPLAYS PLAYER INFORMATION INGAME


class_name PlayerStats
extends Control



# FIELDS ==========



@export var name_button : Label
@export var currency_button : Button



# CALLBACKS ============


# eh whatever
func _process(delta):
	_update_stats()



# PRIVATE ==========



func _update_stats():
	name_button.text = CompanyData.save_name
	currency_button.text = "$" + str(CompanyData.funds)
