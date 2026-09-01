extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(There are some books here with interesting facts about animals.)"},
	{"name": "Detective Fox", "text": "(Apparently tigers have stripes on their skin, not just their fur.)"},
	{"name": "Detective Fox", "text": "(Apparently platypuses are venomous, but only the males.)"},
	{"name": "Detective Fox", "text": "(Apparently flamingos aren't born pink — they start out white or gray.)"},
	{"name": "Detective Fox", "text": "(Pretty interesting stuff. Patients must read a lot when they're bored.)"}
]

var shortLine: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(Pretty interesting stuff. Patients must read a lot when they're bored.)"}
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
	Clues.clue10 = true
