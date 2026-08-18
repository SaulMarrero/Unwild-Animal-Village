extends CharacterBody2D

@onready var player = $"../player"

const walk = 800.0
const run = 3000.0

func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	var current_speed = run if Input.is_action_pressed("run") else walk
	velocity.x = direction * current_speed
	move_and_slide()

	if direction != 0:
		player.get_node("animation").flip_h = direction < 0
	
