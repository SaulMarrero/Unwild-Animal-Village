extends Node2D

@onready var canvaslayer = $player/canvaslayer
@onready var areas: Array[Node] = [$paintings, $books, $platypus]

var fade_time := 1.0
var visitedCount := 0

var finalConversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(It's 6 pm… time for the trial.)"},
	{"name": "Detective Fox", "text": "(This is moving way too fast, we haven't even had time to go over the clues yet.)"},
	{"name": "Detective Fox", "text": "(But Oinker's way too desperate to get those documents back.)"},
	{"name": "Detective Fox", "text": "(Damn impatient old man…)"},
	{"name": "Detective Fox", "text": "Lady Platypus, would you mind if we keep investigating after the trial?"},
	{"name": "Detective Fox", "text": "You know how Mayor Oinker gets about these things..."},
	{"name": "Lady Platypus", "text": "...."},
	{"name": "Lady Platypus", "text": "Yeah, that's fair. It's fine..."},
	{"name": "Detective Fox", "text": "(Seems like bringing up Oinker scared her even more than her supposed robbery.)"}
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

		await _fadeToTrial()

func _fadeToTrial() -> void:
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

	get_tree().change_scene_to_file("res://scenes/trial.tscn")
	layer.queue_free()
