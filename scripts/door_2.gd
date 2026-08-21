extends Area2D
@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective\nFox", "text": "Esta puerta no tiene rastros de haber sido forzada"},
	{"name": "Detective\nFox", "text": "Se intuye que el ladrón entró por la ventana"}
]

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("click"):
		dialog.start_dialog(conversation)
		get_viewport().set_input_as_handled()
