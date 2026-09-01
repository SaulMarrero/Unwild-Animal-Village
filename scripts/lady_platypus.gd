extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Lady Platypus", "text": "It's true, I promise! Someone broke in here!"},
	{"name": "Partner Woof", "text": "Please, calm down! Tell us, what did they steal?"},
	{"name": "Lady Platypus", "text": "I don't know! Something! Please, you have to look... my instinct is never wrong! Someone was here!"},
	{"name": "Detective Fox", "text": "Calm down, okay? We've got a few minutes before the trial. We'll do what we can."},
	{"name": "Detective Fox", "text": "(I just hope this actually has something to do with the case...)"}
]

var shortLine: Array[Dictionary] = [
	{"name": "Lady Platypus", "text": "It's true, I promise! Someone broke in here!"},
	{"name": "Detective Fox", "text": "(I just hope this actually has something to do with the case...)"}
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
		_unlockClue()

func _unlockClue() -> void:
	while dialog.state != dialog.State.CLOSED:
		await get_tree().process_frame
	Clues.clue12 = true
