
# manager and UI container for block palettes
# dynamically instantiates them from companydata


class_name BlockPaletteHolder
extends Control



# FIELDS ==========


signal template_button_pressed(template : PackedScene)

@export var palette_template : PackedScene
@export var blocks_directory : String = "res://Blocks"
@export var palette_container: Control

@export_category("Runtime")
@export var palettes : Array[BlockPalette]



# CALLBACKS ==========



func _ready():
	_add_palettes_from_data()



# PUBLIC ==========



func disable_palettes():
	for palette in palettes:
		palette.disable_button()


func enable_palettes():
	for palette in palettes:
		palette.enable_button()


# delete all and re-add from companydata
func refresh_palettes():
	for palette in palettes: palette.queue_free()
	_add_palettes_from_data()



# PRIVATE ==========



func _add_palette_from_type(block_type : String):
	
	var template = load(blocks_directory + "/" + block_type + ".tscn")
	var palette = palette_template.instantiate()
	palette.block_template = template
	
	palette_container.add_child(palette)
	palettes.append(palette)
	
	var call = Callable(self, "_on_palette_pressed")
	palette.connect("block_palette_selected", call)


func _add_palettes_from_data():
	for block in CompanyData.blocks: _add_palette_from_type(block)


func _on_toggle_palettes_requested(state : bool):
	if state == true: enable_palettes()
	if state == false: disable_palettes()


func _on_palette_pressed(template):
	print("palette holder pressed")
	emit_signal("template_button_pressed", template)
