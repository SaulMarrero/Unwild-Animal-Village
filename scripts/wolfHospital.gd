extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "Alright… I'd like to ask you a few questions about last night."},
	{"name": "Detective Fox", "text": "As you probably know, Mayor Oinker's house was robbed right after you passed out."},
	{"name": "Guard Wolf", "text": "Yeah, that's right. It was late at night, I remember that part pretty clearly."},
	{"name": "Guard Wolf", "text": "I'd gone to the bathroom for a minute, I always sneak that in while I'm working."},
	{"name": "Guard Wolf", "text": "When I came out, the window wasn't broken, everything looked the same."},
	{"name": "Guard Wolf", "text": "But after closing the door and getting back in position, I started feeling this huge pain."},
	{"name": "Guard Wolf", "text": "Not long after, before I even knew what was happening, I woke up in the hospital with the doctor filling me in."},
	{"name": "Partner Woof", "text": "If that's true, then the thief must have waited for Wolf to pass out before breaking in!"},
	{"name": "Detective Fox", "text": "(That's probably it, yeah. Doesn't seem likely he was poisoned in the bathroom, or even before that.)"},
	{"name": "Detective Fox", "text": "We'll let you know if we need to ask anything else."}
]

var shortLine: Array[Dictionary] = [
	{"name": "Guard Wolf", "text": "But after closing the door and getting back in position, I started feeling this huge pain."},
	{"name": "Guard Wolf", "text": "Not long after, before I even knew what was happening, I woke up in the hospital with the doctor filling me in."}
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
	Clues.clue9 = true
