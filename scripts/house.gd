extends Node2D
@onready var dialog = $player/canvaslayer
@onready var camera = $player/camera  # ajusta la ruta si tu cámara está en otro sitio

var camera_move_time := 2.0

func _ready() -> void:
	dialog.external_lock = true

	await get_tree().create_timer(1.0).timeout

	var tween_out := create_tween()
	tween_out.tween_property(camera, "position:x", -1261, camera_move_time)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween_out.finished

	await get_tree().create_timer(1.5).timeout

	var tween_back := create_tween()
	tween_back.tween_property(camera, "position:x", -581, camera_move_time)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await tween_back.finished

	await get_tree().create_timer(1.0).timeout

	dialog.external_lock = false

	var conversation: Array[Dictionary] = [
		{"name": "Mayor Oinker", "text": "Esto es inaceptable! Completamente inaceptable!"},
		{"name": "Mayor Oinker", "text": "Me han robado! A mí! El alcalde de Animal Village!"},
		{"name": "Mayor Oinker", "text": "¿Cómo ha podido pasar? Tengo guardias y puertas con contraseña!"},
	]
	dialog.start_dialog(conversation)
