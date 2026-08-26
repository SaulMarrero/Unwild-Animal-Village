extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(I recognize this painting.)"},
	{"name": "Detective Fox", "text": "(Composition in Red, Yellow, and Blue, by Piet Mondrian.)"},
	{"name": "Detective Fox", "text": "(Not something I'd expect to find in a police station.)"}
]

var shortLine: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(I recognize this painting. Is not something I'd expect to find in a police station though.)"}
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
