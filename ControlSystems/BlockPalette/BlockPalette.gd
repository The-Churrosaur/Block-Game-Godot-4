
# fires block template signal when hit


class_name BlockPalette
extends Control



# FIELDS ==========



signal block_palette_selected(block_template : PackedScene)

@export var block_template : PackedScene
@export var button : TextureButton



# PUBLIC ==========



func enable_button():
	button.disabled = false


func disable_button():
	button.disabled = true



# PRIVATE ==========



func _on_template_button_pressed():
	print("palette detected press")
	emit_signal("block_palette_selected", block_template)
