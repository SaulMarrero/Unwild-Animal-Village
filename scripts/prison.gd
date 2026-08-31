extends Node2D

@onready var canvaslayer = $player/canvaslayer
@onready var meow = $meow

func _ready() -> void:
	music.play_music(preload("res://music/lastTalk.mp3"))
	canvaslayer.show_next()

	var layer := CanvasLayer.new()
	layer.layer = 10
	add_child(layer)

	var rect := ColorRect.new()
	rect.color = Color.BLACK
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(rect)

	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, 1.0)
	tween.tween_callback(layer.queue_free)

	meow.investigated.connect(_onCharacterVisited)

func _onCharacterVisited() -> void:
	while canvaslayer.state != canvaslayer.State.CLOSED:
		await get_tree().process_frame

	await _fadeToHospital()

func _fadeToHospital() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 10
	add_child(layer)

	var rect := ColorRect.new()
	rect.color = Color.BLACK
	rect.modulate.a = 0.0
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(rect)

	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, 1.0)
	await tween.finished

	get_tree().change_scene_to_file("res://scenes/hospital_1.tscn")
	layer.queue_free()
