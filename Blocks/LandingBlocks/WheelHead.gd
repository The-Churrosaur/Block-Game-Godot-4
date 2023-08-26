
# wheel block
# changes subship friction settings etc on ready
class_name WheelHead
extends PinHeadBase


# FIELDS ----------------------------------------------------------------------


@export var physics_material : PhysicsMaterial


# CALLBACKS --------------------------------------------------------------------


func _ready():
	super._ready()
	
	# bad but eh for now
#	await get_tree().process_frame
	
	if !shipBody: return
	
	print("wheelhead OVERRIDING SHIP MATERIAL")
	shipBody.physics_material_override = physics_material


# PUBLIC -----------------------------------------------------------------------





# PRIVATE ----------------------------------------------------------------------





# -- SUBSECTION


