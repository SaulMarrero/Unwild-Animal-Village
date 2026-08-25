extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(It's midnight. The robbery happened 9 hours ago.)"},
	{"name": "Detective Fox", "text": "(Mayor Oinker has been pretty on edge ever since.)"},
	{"name": "Detective Fox", "text": "(We should crack this case as soon as we can.)"}
]

var shortLine: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(We should crack this case as soon as we can.)"}
]

var closedLine: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(I have to see Chief Teddy.)"}
]

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("click") and not get_viewport().gui_get_hovered_control():
		get_viewport().set_input_as_handled()

		if caseClosed:
			dialog.start_dialog(closedLine)
			return

		if visited:
			dialog.start_dialog(shortLine)
			return

		dialog.start_dialog(conversation)
		visited = true
		investigated.emit()
