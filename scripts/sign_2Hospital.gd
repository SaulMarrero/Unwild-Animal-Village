extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(The sign says this is Doctor Meow's office.)"},
	{"name": "Detective Fox", "text": "(That's the doctor Chief Teddy mentioned.)"},
	{"name": "Detective Fox", "text": "(We should pay him a visit once we're done questioning the poisoned guard.)"}
]

var shortLine: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(We should pay him a visit once we're done questioning the poisoned guard.)"}
]

var finalMessage: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(Just like he said, there's a hidden gap behind the sign. And behind it is…)"},
	{"name": "Detective Fox", "text": "(The safe.)"},
	{"name": "Detective Fox", "text": "(As a detective, I've got the keys to open it, in case it ever became relevant to the case.)"},
	{"name": "Detective Fox", "text": "(Should I read the documents like Meow said, or just let Mayor Oinker know?)"},
	{"name": "Detective Fox", "text": "(... I guess one look won't hurt anybody.)"}
]

var fade_time := 1.0

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("click") and not get_viewport().gui_get_hovered_control():
		get_viewport().set_input_as_handled()

		if Clues.unlockedCount() >= 12:
			dialog.start_dialog(finalMessage)
			_waitAndFade()
			return

		if visited:
			dialog.start_dialog(shortLine)
			return

		dialog.start_dialog(conversation)
		visited = true
		investigated.emit()

func _waitAndFade() -> void:
	while dialog.state != dialog.State.CLOSED:
		await get_tree().process_frame
	await _fadeToEnding()

func _fadeToEnding() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 10
	get_tree().root.add_child(layer)

	var rect := ColorRect.new()
	rect.color = Color.BLACK
	rect.modulate.a = 0.0
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(rect)

	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, fade_time)
	await tween.finished

	get_tree().change_scene_to_file("res://scenes/ending.tscn")
	layer.queue_free()
