
# SINGLETON that holds player information (currency) accross workshop and world
# hacked in for now - in the future everything (building) will be in-world?

extends Node


# FIELDS ----------------------------------------------------------------------


signal data_changed()


@export_category("Starting Values")
@export var starting_funds = 10000

@export_category("Save info")
@export var save_dir = ""
@export var save_name = "Save"
@export var world_save_dir = "res://WorldSaves"

@export_category("Data")
@export var funds = 100000
@export var blocks : Array[PackedScene]

# CALLBACKS --------------------------------------------------------------------


func _ready():
	load_data()
	save_dir = DirectoryInfo.get_save_directory()


func _process(delta):
	pass


# PUBLIC -----------------------------------------------------------------------


# resets all saved values to defauts
func reset_data():
	save_name = "Save"
	funds = starting_funds


# -- SAVING LOADING


func save_data(path : String = save_dir):
	
	var res = CompanySaveResource.new()
	
	print("SAVING PLAYER DATA: ", res)
	
	# save data
	
	res.funds = funds
	res.player_name = save_name
	
	var file = path + "/" + save_name + ".tres" # yes you have to add the .tres
	ResourceSaver.save(res, file)


func load_data(path : String = save_dir + "/" + save_name):
	
	var res : CompanySaveResource = ResourceLoader.load(path)
	if res == null: return
	
	# load data
	
	funds = res.funds
	save_name = res.player_name
	
	print("save name loaded: ", save_name)


# PRIVATE ----------------------------------------------------------------------





# -- SUBSECTION


