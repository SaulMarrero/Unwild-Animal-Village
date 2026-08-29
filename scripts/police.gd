extends Node2D

@onready var canvaslayer = $player/canvaslayer
@onready var baseAreas: Array[Node] = [$teddy, $clock, $painting, $furniture, $cork_board]
@onready var stinger = $stinger
@onready var frog = $frog

var fade_time := 1.0
var visitedCount := 0
var areas: Array[Node] = []

var introConversation: Array[Dictionary] = [
	{"name": "Chief Teddy", "text": "These are the only two poisonous animals living in Animal Village."},
	{"name": "Chief Teddy", "text": "Lady Stinger and Mister Croak. They both live nearby."},
	{"name": "Chief Teddy", "text": "You should question them and see if their profile fits."}
]

var finalConversationEarly: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(Now we should go to the hospital.)"},
	{"name": "Detective Fox", "text": "(The poisoned guard should be awake by now.)"}
]

var finalConversationLate: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(It's 6 pm… time for the trial.)"},
	{"name": "Detective Fox", "text": "(This is moving way too fast, we haven't even had time to go over the clues yet.)"},
	{"name": "Detective Fox", "text": "(But Oinker's way too desperate to get those documents back.)"},
	{"name": "Detective Fox", "text": "(Damn impatient old man…)"}
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

	if Clues.unlockedCount() >= 10:
		areas = baseAreas.duplicate()
		areas.append(stinger)
		areas.append(frog)
		await _playIntro()
	else:
		areas = baseAreas

	for area in areas:
		area.investigated.connect(_onAreaVisited)

func _playIntro() -> void:
	canvaslayer.external_lock = true
	while canvaslayer.state != canvaslayer.State.CLOSED:
		await get_tree().process_frame
	canvaslayer.start_dialog(introConversation)
	while canvaslayer.state != canvaslayer.State.CLOSED:
		await get_tree().process_frame
	canvaslayer.external_lock = false

func _onAreaVisited() -> void:
	visitedCount += 1

	if visitedCount >= areas.size():
		while canvaslayer.state != canvaslayer.State.CLOSED:
			await get_tree().process_frame

		if Clues.unlockedCount() >= 10:
			canvaslayer.start_dialog(finalConversationLate)
		else:
			canvaslayer.start_dialog(finalConversationEarly)

		while canvaslayer.state != canvaslayer.State.CLOSED:
			await get_tree().process_frame

		canvaslayer.hide_next()

		for area in areas:
			area.caseClosed = true

		if Clues.unlockedCount() >= 10:
			await _fadeToTrial()
		else:
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
