extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(I wonder if searching this place from top to bottom would turn up the stolen documents.)"},
	{"name": "Detective Fox", "text": "(Probably not. He wouldn't have been dumb enough to leave them out in plain sight.)"}
]

var shortLine: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(I wonder if searching this place from top to bottom would turn up the stolen documents. Probably not)"}
]

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("click") and not get_viewport().gui_get_hovered_control():
		get_viewport().set_input_as_handled()

		if visited:
			if shortLine.size() > 0:
				dialog.start_dialog(shortLine)
			return

		dialog.start_dialog(conversation)
		visited = true
		investigated.emit()
