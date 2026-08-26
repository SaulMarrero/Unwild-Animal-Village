extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Partner Woof", "text": "According to the police, the front door wasn't forced open."},
	{"name": "Partner Woof", "text": "So the thief must have come in through the window, no doubt about it!"},
	{"name": "Detective Fox", "text": "No, that's wrong. The evidence just shows the door wasn't forced."},
	{"name": "Detective Fox", "text": "If there was some kind of poisoning involved, maybe the door was left open and the thief walked right in."},
	{"name": "Detective Fox", "text": "(Still, that wouldn't explain why the window is broken then.)"},
	{"name": "Partner Woof", "text": "Oh, what's this?"},
	{"name": "Detective Fox", "text": "Huh, did you find something, Woof?"},
	{"name": "Partner Woof", "text": "Look at this, under the door… there's a tiny piece of nylon!"},
	{"name": "Partner Woof", "text": "It's really thin, even with my amazing eyesight I can barely see it."},
	{"name": "Partner Woof", "text": "Does it have anything to do with the case?"},
	{"name": "Detective Fox", "text": "(Nylon… a pretty thin cord, one you'd barely notice in the dark of night.)"},
	{"name": "Detective Fox", "text": "I can't tell how it connects to the case, but we should hold onto it."},
	{"name": "Detective Fox", "text": "There's no such thing as coincidence in this line of work."}
]

var shortLine: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "I can't tell how the nylon connects to the case, but we should hold onto it."},
	{"name": "Detective Fox", "text": "There's no such thing as coincidence in this line of work."}
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
	Clues.clue2 = true
