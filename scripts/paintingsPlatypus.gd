extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(Four paintings. According to Woof, that's the number Lady Platypus had.)"},
	{"name": "Detective Fox", "text": "(So no painting was stolen either.)"},
	{"name": "Detective Fox", "text": "(Then what the hell did they steal?)"}
]
var shortLine: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(Then what the hell did they steal?)"}
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
