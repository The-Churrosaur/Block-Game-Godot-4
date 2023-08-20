extends CharacterBody2D

var velocity = Vector2(100,100)

func _physics_process(delta):
	set_velocity(velocity)
	# TODOConverter40 looks that snap in Godot 4.0 is float, not vector like in Godot 3 - previous value `Vector2(0,20)`
	move_and_slide()
	velocity = velocity
