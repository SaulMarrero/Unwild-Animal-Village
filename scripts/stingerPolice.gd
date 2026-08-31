extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "(Placeholder text for Stinger's conversation.)"}
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
