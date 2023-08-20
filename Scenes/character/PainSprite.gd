extends Sprite2D

# temp hitindicator, use animations for this

@onready var player = get_parent()

func _ready():
	player.connect("player_hit", Callable(self, "on_hit"))
	visible = false

func on_hit(body):
	visible = true
	await get_tree().create_timer(0.2).timeout
	visible = false
