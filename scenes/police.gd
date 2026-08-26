extends Node2D

@onready var canvaslayer = $player/canvaslayer
@onready var areas: Array[Node] = [$teddy, $clock, $painting, $furniture, $cock_board]

var fade_time := 1.0
var visitedCount := 0

var finalConversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(Now we should go to the hospital.)"},
	{"name": "Detective Fox", "text": "(The poisoned guard should be awake by now.)"}
]

func _ready() -> void:
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

	for area in areas:
		area.investigated.connect(_onAreaVisited)

func _onAreaVisited() -> void:
	visitedCount += 1

	if visitedCount >= areas.size():
		while canvaslayer.state != canvaslayer.State.CLOSED:
			await get_tree().process_frame

		canvaslayer.start_dialog(finalConversation)

		while canvaslayer.state != canvaslayer.State.CLOSED:
			await get_tree().process_frame

		canvaslayer.hide_next()

		for area in areas:
			area.caseClosed = true

		await _fadeOut()

func _fadeOut() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 10
	add_child(layer)

	var rect := ColorRect.new()
	rect.color = Color.BLACK
	rect.modulate.a = 0.0
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(rect)

	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, fade_time)
	await tween.finished

	get_tree().change_scene_to_file("res://scenes/street.tscn")
	layer.queue_free()
