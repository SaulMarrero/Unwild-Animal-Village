extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(This sign talks about different viruses and various precautions.)"},
	{"name": "Detective Fox", "text": "(People actually stop to read this stuff when they visit a hospital.)"}
]

var shortLine: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(People actually stop to read this stuff when they visit a hospital.)"}
]

var doneMessage: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(The other one)"}
]

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("click") and not get_viewport().gui_get_hovered_control():
		get_viewport().set_input_as_handled()

		if Clues.unlockedCount() >= 12:
			dialog.start_dialog(doneMessage)
			return

		if visited:
			dialog.start_dialog(shortLine)
			return

		dialog.start_dialog(conversation)
		visited = true
		investigated.emit()
