extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(These paintings look really expensive.)"},
	{"name": "Detective Fox", "text": "(Oinker doesn't hold back when it comes to decorating his mansion.)"},
	{"name": "Partner Woof", "text": "Detective, do you think these paintings have something to do with the robbery?!"},
	{"name": "Partner Woof", "text": "I've seen in movies how people hide secret compartments behind paintings."},
	{"name": "Detective Fox", "text": "(... this girl lives on her own planet.)"}
]

var shortLine: Array[Dictionary] = [
	{"name": "Partner Woof", "text": "Detective, do you think these paintings have something to do with the robbery?!"},
	{"name": "Partner Woof", "text": "I've seen in movies how people hide secret compartments behind paintings."},
	{"name": "Detective Fox", "text": "(... this girl lives on her own planet.)"}
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
