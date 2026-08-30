extends Node2D

@onready var canvaslayer = $player/canvaslayer
@onready var areas: Array[Node] = []

var fade_time := 1.0
var visitedCount := 0

var introConversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": ""}
]

var exitConversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(It's 6 pm… time for the trial.)"},
	{"name": "Detective Fox", "text": "(This is moving way too fast, we haven't even had time to go over the clues yet.)"},
	{"name": "Detective Fox", "text": "(But Oinker's way too desperate to get those documents back.)"},
	{"name": "Detective Fox", "text": "(Damn impatient old man…)"}
]

func _ready() -> void:
	canvaslayer.external_lock = true

	var layer := CanvasLayer.new()
	layer.layer = 10
	add_child(layer)

	var rect := ColorRect.new()
	rect.color = Color.BLACK
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(rect)

	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, fade_time)
	await tween.finished
	layer.queue_free()

	canvaslayer.external_lock = false
	canvaslayer.start_dialog(introConversation)

	await get_tree().process_frame

	while canvaslayer.state != canvaslayer.State.CLOSED:
		await get_tree().process_frame

	canvaslayer.show_next()

	for area in areas:
		area.investigated.connect(_onAreaVisited)

func _onAreaVisited() -> void:
	visitedCount += 1

	if visitedCount >= areas.size():
		while canvaslayer.state != canvaslayer.State.CLOSED:
			await get_tree().process_frame

		canvaslayer.start_dialog(exitConversation)

		await get_tree().process_frame

		while canvaslayer.state != canvaslayer.State.CLOSED:
			await get_tree().process_frame

		canvaslayer.hide_next()

		for area in areas:
			area.caseClosed = true

		await _fadeOut("res://scenes/trial.tscn")

func _fadeOut(targetScene: String) -> void:
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

	get_tree().change_scene_to_file(targetScene)
	layer.queue_free()
