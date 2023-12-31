extends TextureButton


@onready var main = self.owner
@export var block = preload("res://Blocks/TestBlock.tscn")

signal send_block_template(block)

func _ready():
	connect("send_block_template", Callable(main, "on_block_select_button_pressed"))
	connect("button_down", Callable(self, "on_button_down"))
	
	# display child
	var instance = block.instantiate()
#	print("printing isntance, ", instance)
	if instance.display_name != null:
		$Label.text = instance.display_name
	else:
		$Label.text = instance.name
	
	add_child(instance)
	
	# jank but eh
	instance.global_position = global_position + Vector2(32,32)
	instance.scale *= 0.5

func on_button_down():
	emit_signal("send_block_template", block)
