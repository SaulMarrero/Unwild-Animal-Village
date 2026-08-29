extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "Doctor, I'd like to ask you a few questions about this whole case."},
	{"name": "Detective Fox", "text": "I understand you've been treating both Chief Teddy and Guard Wolf, is that right?"},
	{"name": "Doctor Meow", "text": "Hm? Yes, that's right. Mr. Teddy's been a regular patient."},
	{"name": "Doctor Meow", "text": "He's had heart failure for a while now, I have to check up on him every so often."},
	{"name": "Detective Fox", "text": "(So it's true. With that confirmed, there's no way Chief Teddy could've committed this crime.)"},
	{"name": "Detective Fox", "text": "As for Guard Wolf, it's safe to assume he was poisoned, correct?"},
	{"name": "Doctor Meow", "text": "No doubt about it. He was poisoned, his symptoms make that clear."},
	{"name": "Doctor Meow", "text": "That said, he didn't pass out from the poison itself, but from the pain it caused, his brain just couldn't take it."},
	{"name": "Doctor Meow", "text": "Also, my colleagues found this pin stuck in Mr. Wolf's hand. Not sure why it was there."},
	{"name": "Partner Woof", "text": "A pin? Nothing at the crime scene really explains what a pin would be doing there."},
	{"name": "Detective Fox", "text": "(That is pretty strange. We'll need to keep that in mind going forward.)"},
	{"name": "Detective Fox", "text": "If we need anything else, we'll come back and ask."}
]

var shortLine: Array[Dictionary] = [
	{"name": "Doctor Meow", "text": "Also, my colleagues found this pin stuck in Mr. Wolf's hand. Not sure why it was there."},
	{"name": "Partner Woof", "text": "A pin? Nothing at the crime scene really explains what a pin would be doing there."},
	{"name": "Detective Fox", "text": "(That is pretty strange. We'll need to keep that in mind going forward.)"}
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
