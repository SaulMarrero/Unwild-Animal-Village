extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversationFirstVisit: Array[Dictionary] = [
	{"name": "Partner Woof", "text": "Excuse me, are you Mr. Teddy, the head of the police officers?"},
	{"name": "Partner Woof", "text": "We're here to gather information about the robbery at Mayor Oinker's house."},
	{"name": "Chief Teddy", "text": "Chief, not mister."},
	{"name": "Chief Teddy", "text": "Oinker let me know you'd be stopping by. Ask whatever you need."},
	{"name": "Detective Fox", "text": "(What a character…)"},
	{"name": "Detective Fox", "text": "I'm guessing you already know some important documents were stolen from the mayor's house."},
	{"name": "Detective Fox", "text": "Mayor Oinker told us you knew those documents existed."},
	{"name": "Detective Fox", "text": "And you also knew the password to the door protecting them. That makes you a suspect."},
	{"name": "Chief Teddy", "text": "Yeah, I've heard that too. It's true I'm the only one he told everything to."},
	{"name": "Chief Teddy", "text": "Mayor Oinker gave me some papers with all his passwords and security details."},
	{"name": "Chief Teddy", "text": "I always keep them on me, in my briefcase, which I carry everywhere."},
	{"name": "Chief Teddy", "text": "And my officers aren't allowed to touch it. The station's cameras would've caught them anyway."},
	{"name": "Partner Woof", "text": "So… do you have anything to add? Because if that's true, you're the only one who could've done it!"},
	{"name": "Chief Teddy", "text": "That can't be right. The witness said the thief ran off."},
	{"name": "Detective Fox", "text": "And why would that rule you out as a suspect?"},
	{"name": "Chief Teddy", "text": "Because I can't run."},
	{"name": "Chief Teddy", "text": "I have heart failure. I go to the hospital every week to get checked."},
	{"name": "Chief Teddy", "text": "You can ask Doctor Meow yourselves. I don't match the suspect's profile."},
	{"name": "Detective Fox", "text": "(If we can confirm this, Chief Teddy couldn't have run off after leaving the scene.)"},
	{"name": "Detective Fox", "text": "(Assuming, of course, that Miss Sheep's story is accurate.)"},
	{"name": "Detective Fox", "text": "(But we have no reason to doubt it for now.)"}
]

var conversationSecondVisit: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(Placeholder text for Teddy's second conversation.)"}
]

var shortLine: Array[Dictionary] = []

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("click") and not get_viewport().gui_get_hovered_control():
		get_viewport().set_input_as_handled()

		if visited:
			if shortLine.size() > 0:
				dialog.start_dialog(shortLine)
			return

		if Clues.unlockedCount() >= 9:
			dialog.start_dialog(conversationSecondVisit)
		else:
			dialog.start_dialog(conversationFirstVisit)
			_unlockClues()

		visited = true
		investigated.emit()

func _unlockClues() -> void:
	while dialog.state != dialog.State.CLOSED:
		await get_tree().process_frame
	Clues.clue6 = true
	Clues.clue7 = true
