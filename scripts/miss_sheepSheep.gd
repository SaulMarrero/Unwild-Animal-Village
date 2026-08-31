extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "Excuse me… you're Miss Sheep, right?"},
	{"name": "Detective Fox", "text": "Good morning, we're from the Animal Village detective agency."},
	{"name": "Detective Fox", "text": "We're here to hear your statement about the robbery at Mayor Oinker's house yesterday."},
	{"name": "Miss Sheep", "text": "Oh my… so it really was a robbery, huh? Hard to believe anyone would have the nerve to rob Oinker."},
	{"name": "Miss Sheep", "text": "I don't really have much to tell. Yesterday I woke up in the middle of the night after hearing a noise."},
	{"name": "Miss Sheep", "text": "I got up, looked out the window, and saw someone running off in the other direction."},
	{"name": "Miss Sheep", "text": "I couldn't see their face, so I called the police right away."},
	{"name": "Miss Sheep", "text": "They showed up pretty fast."},
	{"name": "Partner Woof", "text": "Tell me, Miss Sheep, how do we know it wasn't you who did it and just hid out here?"},
	{"name": "Partner Woof", "text": "Is there anyone who can confirm you were asleep at that hour?"},
	{"name": "Miss Sheep", "text": "I… no, honestly, I live alone. My friends walked me home after work around 11 pm."},
	{"name": "Miss Sheep", "text": "After that I stayed home, and nobody lives with me. But I swear it wasn't me!"},
	{"name": "Detective Fox", "text": "(She doesn't have an alibi, but I don't see a real reason to doubt her.)"},
	{"name": "Detective Fox", "text": "(If she'd been the thief, she wouldn't have called the police right after pulling off the robbery.)"},
	{"name": "Detective Fox", "text": "(That would be a pretty risky move. And her story lines up with the evidence so far.)"},
	{"name": "Detective Fox", "text": "Thanks for your help, Miss Sheep. We'll reach out if we need anything else from you."},
	{"name": "Miss Sheep", "text": "No problem at all, really. Happy to help!"}
]

var shortLine: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(She doesn't have an alibi, but I don't see a real reason to doubt her.)"},
	{"name": "Detective Fox", "text": "(If she'd been the thief, she wouldn't have called the police right after pulling off the robbery.)"},
	{"name": "Detective Fox", "text": "(That would be a pretty risky move. And her story lines up with the evidence so far.)"}
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
	Clues.clue5 = true
