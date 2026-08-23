extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(Oinker's mansion even comes with a built-in fireplace.)"},
	{"name": "Detective Fox", "text": "(A lot of people would kill for one of these when winter comes.)"},
	{"name": "Mayor Oinker", "text": "Oh, I see you have good taste. Do you like traditional fireplaces, detective?"},
	{"name": "Mayor Oinker", "text": "Check out how great mine is! It's the best one in all of Animal Village!"},
	{"name": "Mayor Oinker", "text": "[Lights the fire]"},
	{"name": "Mayor Oinker", "text": "This smell, this warmth… nothing beats reading a book on the couch with the fire going!"},
	{"name": "Detective Fox", "text": "(You haven't read a book in your life, you bastard…)"}
]

var shortLine: Array[Dictionary] = [
	{"name": "Mayor Oinker", "text": "This smell, this warmth… nothing beats reading a book on the couch with the fire going!"},
	{"name": "Detective Fox", "text": "(You haven't read a book in your life, you bastard…)"}
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
