extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "We don't have much time, so let's get straight to it."},
	{"name": "Detective Fox", "text": "Do you have an alibi?"},
	{"name": "Lady Stinger", "text": "Straight to the point, huh... No, I don't. I was home alone, you know? Never left the house."},
	{"name": "Lady Stinger", "text": "But it couldn't have been me! My venom has to be injected through my stinger..."},
	{"name": "Lady Stinger", "text": "A guard would've seen me coming if I'd attacked him, don't you think?"},
	{"name": "Detective Fox", "text": "(Yeah, I guess she's got a point.)"}
]

var shortLine: Array[Dictionary] = []

func _ready() -> void:
	_updateVisibility()

func _updateVisibility() -> void:
	var unlocked := Clues.unlockedCount() >= 9
	visible = unlocked
	set_deferred("monitoring", unlocked)
	set_deferred("monitorable", unlocked)

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("click") and not get_viewport().gui_get_hovered_control():
		get_viewport().set_input_as_handled()

		if visited:
			if shortLine.size() > 0:
				dialog.start_dialog(shortLine)
			return

		dialog.start_dialog(conversation)
		visited = true
		investigated.emit()
		_unlockClue()

func _unlockClue() -> void:
	while dialog.state != dialog.State.CLOSED:
		await get_tree().process_frame
	Clues.clue11 = true
