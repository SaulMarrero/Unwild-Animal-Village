extends Area2D
@onready var dialog = $"../player/canvaslayer"
var conversation: Array[Dictionary] = [
	{"name": "Detective\nFox", "text": "Hola soy la oveja"},
	{"name": "Detective\nFox", "text": "Vivo aquí en el pueblo"}
]

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("click") and not get_viewport().gui_get_hovered_control():
		dialog.start_dialog(conversation)
		get_viewport().set_input_as_handled()
