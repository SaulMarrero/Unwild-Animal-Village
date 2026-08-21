extends Area2D
@onready var dialog = $"../player/canvaslayer"

var conversation: Array[Dictionary] = [
	{"name": "Detective\nFox", "text": "La ventana está rota"},
	{"name": "Detective\nFox", "text": "Me pregunto que habrá sucedido"}
]

func _on_input_event(_viewport, event, _shape_idx) -> void:
	if event.is_action_pressed("click"):
		dialog.start_dialog(conversation)
		get_viewport().set_input_as_handled()
