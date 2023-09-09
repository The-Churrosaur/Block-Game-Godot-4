
# SINGLETON that holds player information (currency) accross workshop and world
# hacked in for now - in the future everything (building) will be in-world?

extends Node


# FIELDS ----------------------------------------------------------------------


@export var funds = 100000

@export var save_dir = "res://Saves"
@export var save_name = "Save"


# CALLBACKS --------------------------------------------------------------------


func _ready():
	load_data()


func _process(delta):
	pass


# PUBLIC -----------------------------------------------------------------------


func save_data(path : String = save_dir):
	
	var res = CompanySaveResource.new()
	
	print("SAVING PLAYER DATA: ", res)
	
	# save data
	
	res.funds = funds
	
	var file = path + "/" + save_name + ".tres" # yes you have to add the .tres
	ResourceSaver.save(res, file)


func load_data(path : String = save_dir + "/" + save_name):
	
	var res : CompanySaveResource = ResourceLoader.load(path)
	if res == null: return
	
	# load data
	
	funds = res.funds


# PRIVATE ----------------------------------------------------------------------





# -- SUBSECTION


