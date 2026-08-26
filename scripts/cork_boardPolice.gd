extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(The classic corkboard every police station seems to have.)"},
	{"name": "Detective Fox", "text": "(Looks empty. Not surprising, crime's pretty rare in Animal Village.)"}
]

var shortLine: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(Looks empty. Not surprising, crime's pretty rare in Animal Village.)"}
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
