extends Area2D
@onready var dialog = $"../player/canvaslayer"

var conversation1: Array[Dictionary] = [
	{"name": "Partner\nWoof", "text": "According to Mayor Oinker, the police estimate the house was robbed around 3am"},
	{"name": "Partner\nWoof", "text": "The witness said she called the police immediately after hearing a loud noise"},
	{"name": "Partner\nWoof", "text": "Since the police station is close by, they arrived within just a few minutes"},
	{"name": "Partner\nWoof", "text": "Should we go question the witness later?!"},
	{"name": "Detective\nFox", "text": "(... something feels off about that story. But it's probably best not to dwell on it for now)"},
	{"name": "Detective\nFox", "text": "Yeah, we'll need to pay the witness a visit"},
	{"name": "Detective\nFox", "text": "But for now, let's focus on searching this house from top to bottom"},
	{"name": "Partner\nWoof", "text": "Of course!"},
]

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("click") and not get_viewport().gui_get_hovered_control():
		dialog.start_dialog(conversation1)
		get_viewport().set_input_as_handled()
