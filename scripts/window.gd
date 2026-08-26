extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(The broken window… definitely the most suspicious thing in this whole equation.)"},
	{"name": "Detective Fox", "text": "(If the thief came in through here, they must have left some kind of clue.)"},
	{"name": "Partner Woof", "text": "That's weird, there's no broken glass inside the house… could it have broken from the inside out?"},
	{"name": "Mayor Oinker", "text": "Oh, no! It's nothing like that. I personally asked the police to clean all this up."},
	{"name": "Mayor Oinker", "text": "I can't have my mansion full of dangerous, sharp glass lying around, can I?"},
	{"name": "Detective Fox", "text": "(You can't just clean up a crime scene, you damn idiot!)"},
	{"name": "Detective Fox", "text": "Was anything found around the window? Hair, fingerprints… nothing at all?"},
	{"name": "Mayor Oinker", "text": "I don't really know the details, but if something like that had been found, I'm sure I'd already know."},
	{"name": "Mayor Oinker", "text": "It would be unacceptable to leave out such an important detail from me!"},
	{"name": "Mayor Oinker", "text": "So you can assume the thief didn't leave any trace at all!"},
	{"name": "Partner Woof", "text": "That's pretty suspicious. Is there really a thief in Animal Village that well prepared?"},
	{"name": "Detective Fox", "text": "(No, I doubt it. Something's not adding up here.)"},
	{"name": "Detective Fox", "text": "Look, Woof. The window opening isn't especially big."},
	{"name": "Detective Fox", "text": "Someone large, like Mayor Oinker for example, would have a hard time fitting through without leaving some kind of mark."},
	{"name": "Partner Woof", "text": "That's true! We should narrow down our suspects to animals of average or small build, then!"},
	{"name": "Detective Fox", "text": "(This is probably a crucial clue for the case.)"}
]

var shortLine: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "Someone large, like Mayor Oinker for example, would have a hard time fitting through without leaving some kind of mark."},
	{"name": "Partner Woof", "text": "That's true! We should narrow down our suspects to animals of average or small build, then!"}
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
	Clues.clue3 = true
