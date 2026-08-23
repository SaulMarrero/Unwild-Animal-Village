extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(This is the room where Mayor Oinker kept his stolen documents.)"},
	{"name": "Detective Fox", "text": "(But the door has a password.)"},
	{"name": "Detective Fox", "text": "(Did the thief know it beforehand?)"},
	{"name": "Detective Fox", "text": "Tell me, Mayor Oinker. Did the police mention if this door was forced open?"},
	{"name": "Mayor Oinker", "text": "No, from what they told me, the door was already open when they got to the scene."},
	{"name": "Mayor Oinker", "text": "Someone definitely typed in the password."},
	{"name": "Partner Woof", "text": "Who else besides you knew the password?"},
	{"name": "Mayor Oinker", "text": "Well, just the police chief, of course! Chief Teddy!"},
	{"name": "Mayor Oinker", "text": "Why would he steal the documents from me? He works directly under me!"},
	{"name": "Detective Fox", "text": "(Now that's a mystery I'll have to solve myself.)"}
]

var shortLine: Array[Dictionary] = [
	{"name": "Mayor Oinker", "text": "Why would Chief Teddy steal the documents from me? He works directly under me!"},
	{"name": "Detective Fox", "text": "(Now that's a mystery I'll have to solve myself.)"}
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
		_unlockClue()

func _unlockClue() -> void:
	while dialog.state != dialog.State.CLOSED:
		await get_tree().process_frame
	Clues.clue1 = true
