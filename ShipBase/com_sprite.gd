

# simple node that tracks the ship's COM

class_name ComSprite
extends Sprite2D


@export var ship : ShipBody


func _process(delta):
	if ship == null : return
	position = ship.center_of_mass
