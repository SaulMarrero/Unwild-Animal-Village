extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(I can see a lot of literary classics on this shelf.)"},
	{"name": "Detective Fox", "text": "(I'm pretty sure Oinker hasn't read a single one of these, it's just for show.)"},
	{"name": "Detective Fox", "text": "(The amount of dust on each one gives it away.)"}
]

var shortLine: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(I'm pretty sure Oinker hasn't read a single one of these, it's just for show.)"}
]

var closedLine: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(I have to get out of this place.)"}
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
