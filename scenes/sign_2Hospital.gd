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

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("click") and not get_viewport().gui_get_hovered_control():
		get_viewport().set_input_as_handled()

		if visited:
			dialog.start_dialog(shortLine)
			return

		dialog.start_dialog(conversation)
		visited = true
		investigated.emit()
