extends Area2D

signal investigated

var visited := false
var caseClosed := false

@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Doctor Meow", "text": "Thank you for coming, Detective. I was hoping you would."},
	{"name": "Detective Fox", "text": "Dealing with criminals before their sentencing doesn't exactly help my image..."},
	{"name": "Detective Fox", "text": "Is what you promised true? Will you tell me where the documents are?"},
	{"name": "Doctor Meow", "text": "Behind the sign in front of my office, at the hospital."},
	{"name": "Doctor Meow", "text": "There's a hidden slot. You'll find the safe behind it."},
	{"name": "Detective Fox", "text": "...why did you do it, Doctor? You used to be a moral, fair, kind person."},
	{"name": "Detective Fox", "text": "Stealing from Mayor Oinker, jerk or not, crosses every line there is."},
	{"name": "Doctor Meow", "text": "Heh. You'll understand soon enough, Detective Fox."},
	{"name": "Doctor Meow", "text": "Good luck. You're going to need it."},
	{"name": "Detective Fox", "text": "..."}
]

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("click") and not get_viewport().gui_get_hovered_control():
		get_viewport().set_input_as_handled()

		dialog.start_dialog(conversation)
		visited = true
		investigated.emit()
