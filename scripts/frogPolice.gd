extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective Fox", "text": "We don't have much time, so let's get straight to it."},
	{"name": "Detective Fox", "text": "Do you have an alibi?"},
	{"name": "Mister Croak", "text": "I do."},
	{"name": "Detective Fox", "text": "Huh? You actually have one?"},
	{"name": "Lady Stinger", "text": "Mister Croak works long hours at the supermarket. Anyone can confirm he was busy yesterday!"},
	{"name": "Detective Fox", "text": "(Then why the hell did Teddy even bring him here?! Useless idiots...)"}
]

var shortLine: Array[Dictionary] = []

func _ready() -> void:
	_updateVisibility()

func _updateVisibility() -> void:
	var unlocked := Clues.unlockedCount() >= 10
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
