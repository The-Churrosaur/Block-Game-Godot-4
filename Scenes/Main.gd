extends Node2D


@export var scene : PackedScene


func _ready():
	# launch test scene
	get_tree().change_scene_to_packed(scene)
