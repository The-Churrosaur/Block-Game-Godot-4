
# fires block template signal when hit


class_name BlockPalette
extends MarginContainer



# FIELDS ==========



signal block_palette_selected(block_template : PackedScene)

@export var block_template : PackedScene
@export var button : TextureButton
@export var label : Label



# CALLBACKS ===========


func _ready():
	_setup_visuals()


# PUBLIC ==========



func enable_button():
	button.disabled = false


func disable_button():
	button.disabled = true



# PRIVATE ==========



func _setup_visuals():
	
	# display child
	var instance = block_template.instantiate()
	button.add_child(instance)
	
	# eh
	instance.scale *= 0.5
	instance.position += Vector2(32,32)
	
	# display name
	if instance.display_name != null:
		label.text = instance.display_name
	else:
		label.text = instance.name


func _on_template_button_pressed():
	print("palette detected press")
	emit_signal("block_palette_selected", block_template)
