extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(It doesn't look like any of these books have been moved in months.)"},
	{"name": "Detective Fox", "text": "(The dust gives it away.)"},
	{"name": "Detective Fox", "text": "(Not like there's anything valuable in here anyway...)"}
]
var shortLine: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(Not like there's anything valuable in here anyway...)"}
]

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("click") and not get_viewport().gui_get_hovered_control():
		get_viewport().set_input_as_handled()

		if visited:
			dialog.start_dialog(shortLine)
			return

		dialog.start_dialog(conversation)
		visited = true
		investigated.emit()
